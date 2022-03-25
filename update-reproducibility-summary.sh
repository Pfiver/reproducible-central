#!/bin/bash

echo "*** running script: $0"

export LC_ALL=C

#for metadata in $(find content -name "maven-metadata.xml" -print | sort)
for metadata in content/org/apache/maven/doxia/doxia/maven-metadata.xml
do
  dir="$(dirname "${metadata}")"
  readme="${dir}/README.md"
  \rm -f $readme

  t="${readme}.tmp"
  countVersion=0
  countVersionOk=0

  for version in $(tac "${metadata}" | grep 'version>' | cut -d '>' -f 2 | cut -d '<' -f 1)
  do
    buildspec=$(ls $dir | grep "\-${version}.buildspec")
    if [ -n "$buildspec" ]
    then
      . $dir/${buildspec}
      if [ ! -f "${readme}" ]
      then
        # prepare README.md intro
        echo "[$groupId:$artifactId](https://search.maven.org/artifact/${groupId}/${artifactId}/) RB check" > $readme
        echo "=======" >> $readme
        echo >> $readme
        echo "[![Reproducible Builds](https://reproducible-builds.org/images/logos/rb.svg) an independently-verifiable path from source to binary code](https://reproducible-builds.org/)" >> $readme
        echo >> $readme
        echo "## Project: [$groupId:$artifactId](https://search.maven.org/artifact/${groupId}/${artifactId}/)" >> $readme
        echo >> $readme
        echo "Source code: [$gitRepo]($gitRepo)" >> $readme
        echo >> $readme
      fi
      # add buildspec result to tmp
      ((countVersion++))
      # reset recent fields added to buildspec, to avoid rework of older specs
      diffoscope=
      issue=

      if [ $(ls ${dir}/${buildinfo} | wc -l) -le 1 ]; then
        buildinfoCompare="$(basename ${buildinfo} .buildinfo).buildcompare"
      else
        buildinfoCompare="$(basename ${buildspec} .buildspec).buildcompare"
      fi

      echo -n "| [${version}](https://search.maven.org/artifact/${groupId}/${artifactId}/${version}/pom) " >> ${t}
      echo -n "| [${tool} jdk${jdk}" >> ${t}
      [[ "${newline}" == crlf* ]] && echo -n " w" >> ${t}
      echo -n "](${buildspec}) | " >> ${t}
      [ -f "${buildinfo}" ] && echo -n "[result](${buildinfo}): " >> ${t}

      . "${dir}/${buildinfoCompare}"
      if [ $? -eq 0 ]; then
        echo -n "[" >> ${t}
        [ "${ok}" -gt 0 ] && echo -n "${ok} :heavy_check_mark: " >> ${t}
        [ "${ko}" -gt 0 ] && echo -n " ${ko} :warning:" || ((countVersionOk++)) >> ${t}
        echo -n "](${buildinfoCompare})" >> ${t}
        [[ -z "${issue}" ]] || echo -n "[:mag:](${issue})" >> ${t}
        [[ -n "${issue}" ]] && [ "${ko}" -eq 0 ] && echo -e "\n\033[1;31munexpected issue/diffoscope entry when ko=0\033[0m in \033[1m$dir/$buildspec\033[0m" >> ${t}
      else
        echo -n ":x:" >> ${t}
      fi
      echo " |" >> ${t}
    else
      # no buildspec, just list version to tmp
      echo "| [${version}](https://search.maven.org/artifact/${groupId}/${artifactId}/${version}/pom) | | |" >> "${t}"
    fi
  done

  echo "rebuilding **${countVersion} releases** of ${groupId}:${artifactId}:" >> $readme
  echo "- **${countVersionOk}** releases were found successfully **fully reproducible** (100% reproducible artifacts :heavy_check_mark:)," >> $readme
  echo "- $((countVersion - countVersionOk)) had issues (some unreproducible artifacts :warning:):" >> $readme
  echo >> $readme
  echo "| version | [build spec](BUILDSPEC.md) | [result](https://reproducible-builds.org/docs/jvm/): reproducible? |" >> $readme
  echo "| -- | --------- | ------ |" >> $readme
  cat ${t} >> "${readme}"
  \rm -f ${t}

  # add projet entry to main README

  # debug
  cat $readme
done

exit

cat <(echo "| [Central Repository](https://search.maven.org/) groupId:artifactId(s) | version | [build spec](BUILDSPEC.md) | [result](https://reproducible-builds.org/docs/jvm/):<br/>reproducible? |"
echo "| -------------------------------- | -- | --------- | ------ |"

anchor="empty"
countGa=0
countVersion=0
countVersionOk=0

for buildspec in $(find content -name "*.buildspec" -print | sort)
do
  ((countVersion++))
  # reset recent fields added to buildspec, to avoid rework of older specs
  diffoscope=
  issue=

  . "$buildspec"
  new_anchor="${groupId}:${artifactId}"
  [[ -z "${issue}" ]] && [[ -n "${diffoscope}" ]] && issue="$(dirname "${buildspec}")/$(basename "${diffoscope}")"

  buildinfo="$(dirname "${buildspec}")/$(basename "${buildinfo}")"
  if [ $(ls ${buildinfo} | wc -l) -le 1 ]; then
    buildinfoCompare="$(dirname "${buildinfo}")/$(basename ${buildinfo} .buildinfo).buildcompare"
  else
    buildinfoCompare="$(dirname "${buildspec}")/$(basename "${buildspec}" .buildspec).buildcompare"
  fi

  echo -n "| "
  [[ "${new_anchor}" != "${anchor}" ]] && echo -n "<a name='${new_anchor}'></a>[${display}](https://search.maven.org/artifact/${groupId}/${artifactId}) " && ((countGa++))
  anchor="${new_anchor}"
  #echo -n "| [${version}](https://search.maven.org/artifact/${groupId}/${artifactId}/${version}/pom) "
  echo -n "| ${version} "
  echo -n "| [${tool} j${jdk}"
  [[ "${newline}" == crlf* ]] && echo -n " w"
  echo -n "](https://github.com/jvm-repo-rebuild/reproducible-central/tree/master/${buildspec}) | "
  [ -f "${buildinfo}" ] && echo -n "[result](https://github.com/jvm-repo-rebuild/reproducible-central/tree/master/${buildinfo}): "

  . "${buildinfoCompare}"
  if [ $? -eq 0 ]; then
    echo -n "["
    [ "${ok}" -gt 0 ] && echo -n "${ok} :heavy_check_mark: "
    [ "${ko}" -gt 0 ] && echo -n " ${ko} :warning:" || ((countVersionOk++))
    echo -n "](https://github.com/jvm-repo-rebuild/reproducible-central/tree/master/${buildinfoCompare})"
    [[ -z "${issue}" ]] || echo -n "[:mag:](${issue})"
    [[ -n "${issue}" ]] && [ "${ko}" -eq 0 ] && echo -e "\n\033[1;31munexpected issue/diffoscope entry when ko=0\033[0m in \033[1m$buildspec\033[0m"
  else
    echo -n ":x:"
  fi
  echo " |"

done

echo "| **Count: ${countGa}** | **${countVersion}** | | **${countVersionOk}** :heavy_check_mark: **$((countVersion - countVersionOk))** :warning: |"

echo "rebuilding **${countVersion} releases** of **${countGa} projects**:" > summary-intro.md
echo "- **${countVersionOk}** releases were found successfully **fully reproducible** (100% reproducible artifacts :heavy_check_mark:)," >> summary-intro.md
echo "- $((countVersion - countVersionOk)) had issues (some unreproducible artifacts :warning:):" >> summary-intro.md
) > summary-table.md

lead='^<!-- BEGIN GENERATED RESULTS TABLE -->$'
tail='^<!-- END GENERATED RESULTS TABLE -->$'
lead_intro='^<!-- BEGIN GENERATED INTRO -->$'
tail_intro='^<!-- END GENERATED INTRO -->$'
sed -e "/$lead/,/$tail/{ /$lead/{p; r summary-table.md
        }; /$tail/p; d }" README.md | \
    sed -e "/$lead_intro/,/$tail_intro/{ /$lead_intro/{p; r summary-intro.md
        }; /$tail_intro/p; d }" > README.md.tmp

mv README.md.tmp README.md

rm summary-intro.md
rm summary-table.md

if grep "unexpected issue" README.md; then
  echo "Uh oh, found 'unexpected issue' in README.md."
  exit 1
else
  echo "All appears well, no 'unexpected issue' in README.md"
fi

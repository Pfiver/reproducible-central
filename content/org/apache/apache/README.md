[org.apache:apache](https://search.maven.org/artifact/org.apache/apache/) RB check
=======

[![Reproducible Builds](https://reproducible-builds.org/images/logos/rb.svg) an independently-verifiable path from source to binary code](https://reproducible-builds.org/)

## Project: [org.apache:apache](https://search.maven.org/artifact/org.apache/apache/)

Source code: [https://github.com/apache/maven-apache-parent.git](https://github.com/apache/maven-apache-parent.git)

rebuilding **5 releases** of org.apache:apache:
- **4** releases were found successfully **fully reproducible** (100% reproducible artifacts :heavy_check_mark:),
- 1 had issues (some unreproducible artifacts :warning:, see eventual :mag: diffoscope and/or :memo: issue tracker links):

| version | [build spec](/BUILDSPEC.md) | [result](https://reproducible-builds.org/docs/jvm/): reproducible? | size |
| -- | --------- | ------ | -- |
| [27](https://search.maven.org/artifact/org.apache/apache/27/pom) | [mvn jdk8](apache-27.buildspec) | [result](apache-27.buildinfo): [2 :heavy_check_mark: ](apache-27.buildcompare) | 45K |
| [26](https://search.maven.org/artifact/org.apache/apache/26/pom) | [mvn jdk8](apache-26.buildspec) | [result](apache-26.buildinfo): [2 :heavy_check_mark: ](apache-26.buildcompare) | 45K |
| [25](https://search.maven.org/artifact/org.apache/apache/25/pom) | [mvn jdk8](apache-25.buildspec) | [result](apache-25.buildinfo): [2 :heavy_check_mark: ](apache-25.buildcompare) | 44K |
| [24](https://search.maven.org/artifact/org.apache/apache/24/pom) | [mvn jdk8](apache-24.buildspec) | [result](apache-24.buildinfo): [ 1 :warning:](apache-24.buildcompare) [:memo:](https://issues.apache.org/jira/browse/MPOM-265) | 23K |
| [23](https://search.maven.org/artifact/org.apache/apache/23/pom) | [mvn jdk8](apache-23.buildspec) | [result](apache-23.buildinfo): [1 :heavy_check_mark: ](apache-23.buildcompare) | 18K |

<i>(size is calculated without javadoc, that has been excluded from reproducibility checks)</i>

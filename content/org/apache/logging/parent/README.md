[org.apache.logging:logging-parent](https://search.maven.org/artifact/org.apache.logging/logging-parent/) RB check
=======

[![Reproducible Builds](https://reproducible-builds.org/images/logos/rb.svg) an independently-verifiable path from source to binary code](https://reproducible-builds.org/)

## Project: [org.apache.logging:logging-parent](https://search.maven.org/artifact/org.apache.logging/logging-parent/)

Source code: [https://github.com/apache/logging-parent.git](https://github.com/apache/logging-parent.git)

rebuilding **2 releases** of org.apache.logging:logging-parent:
- **1** releases were found successfully **fully reproducible** (100% reproducible artifacts :heavy_check_mark:),
- 1 had issues (some unreproducible artifacts :warning:, see eventual :mag: diffoscope and/or :memo: issue tracker links):

| version | [build spec](/BUILDSPEC.md) | [result](https://reproducible-builds.org/docs/jvm/): reproducible? | size |
| -- | --------- | ------ | -- |
| [5](https://search.maven.org/artifact/org.apache.logging/logging-parent/5/pom) | [mvn jdk8](logging-parent-5.buildspec) | [result](logging-parent-5.buildinfo): [2 :heavy_check_mark: ](logging-parent-5.buildcompare) | 10K |
| [4](https://search.maven.org/artifact/org.apache.logging/logging-parent/4/pom) | [mvn jdk8](logging-parent-4.buildspec) | [result](logging-parent-4.buildinfo): [1 :heavy_check_mark:  1 :warning:](logging-parent-4.buildcompare) [:mag:](logging-parent-4.diffoscope) [:memo:](https://github.com/apache/logging-parent/pull/3) | 10K |

<i>(size is calculated without javadoc, that has been excluded from reproducibility checks)</i>

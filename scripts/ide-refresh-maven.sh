#!/usr/bin/env bash
# Prepara proyecto para Cursor / Extension Pack for Java (import Maven desde pom.xml).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
export JAVA_HOME="${JAVA_HOME:-/usr/lib/jvm/temurin-17-jdk-amd64}"
export PATH="$JAVA_HOME/bin:$PATH"

cd "$ROOT"
echo "JAVA_HOME=$JAVA_HOME"
echo "Proyecto: $ROOT"

# Metadatos Eclipse/lib confunden al language server si compiten con Maven.
rm -f .classpath .project
rm -rf .settings lib

mvn -q dependency:resolve
mvn -q -DskipTests compile

echo ""
echo "OK — Maven compile listo (sin .classpath manual)."
echo ""
echo "Cursor:"
echo "  1. Deshabilitar extensión 'Java' de Oracle (oracle.oracle-java) — conflicta con redhat.java"
echo "  2. File → Open Folder → $ROOT"
echo "  3. Java: Clean Java Language Server Workspace → Reload and delete"
echo "  4. Java: Import Java projects in workspace"
echo "  5. Explorador → JAVA PROJECTS → O365InboxAttachmentToDisk"

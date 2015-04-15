#!/bin/bash
# vim: fdm=marker

getMeta() { # getMeta <metafield> <file> #{{{
    local field="$1" file="$2";
    sed -n '/^---$/,/^\.\.\.$/p' $file | \
        grep "^${field}:" | \
        cut -d' ' -f2- \
    || return 1;
} #}}}
firstLineOf() { # firstLineOf <file> #{{{
    local endOfYaml=$(sed -n '/^\.\.\.$/=' "$1")
    local tryLine="" tryNum=$((endOfYaml + 1))
    while [[ -z $tryLine ]]; do
        tryLine=$(sed -n -e "${tryNum}p" "$1" | \
                  sed -e 's/^[|>] //' \
                      -e 's/[][]//g' \
                      -e 's/^#.*//' \
                      -e 's/^--.*//');
        (( tryNum ++ ));
    done
    echo "$tryLine";
} #}}}
backLinksOf() { # backLinksOf <file> <in files> #{{{
    local search="${1}"; shift; local glob="$@";
    grep -ql "$search" $glob || return 1;
} #}}}

FILE="$1"; shift;
case "$FILE" in
    *.back)      # backlinks: compile.sh a.back a.txt #{{{
        found=( $(backLinksOf "$(basename ${FILE%.*}).html" ${1%/*}/*.${1##*.}) );
        if [[ $? -ne 0 ]]; then
            echo "[_island._](../islands.html) <!--__ISLAND__-->"; exit;
        fi
        for f in "${found[@]}"; do
            echo -n "- [$(getMeta title "$f")](../$(basename ${f%.*}).html)";
            echo -n '<span class="daisy">'
            echo -n "[&phi;]($(basename ${f%.*}).html)";
            echo '</span>'
        done
        ;; #}}}
    *island*)    # islands: compile.sh islands.txt *.txt #{{{
        for f in $(grep -l "__ISLAND__" "$@"); do
            echo "- [$(getMeta title "$f")]($(basename ${f%.*}).html)";
        done
        ;; #}}}
    *hapax*)      # hapax: compile.sh hapax.txt *.hapax #{{{
        for word in $(sort $FILE); do
            f=$(grep -liwq "^$word$" "$@");
            grep -qv "^[^0-9A-Za-z]" <<< $word && \
            echo "[$word]($(basename ${f%.*}).html)";
        done
        ;; #}}}
    *first-*)     # first-lines: compile.sh first-lines.txt *.txt #{{{
        for f in "$@"; do
            echo "[$(firstLineOf "$f")]($(basename ${f%.*}).html)";
        done
        ;; #}}}
    *common-*)    # common-titles: compile.sh common-titles.txt *.txt #{{{
        for f in "$@"; do
            echo "[$(getMeta title "$f")]($(basename ${f%.*}).html)";
        done
        ;; #}}}
    *toc*)        # table of contents: compile.sh toc.txt *.txt #{{{
        for f in "$@"; do
            echo "#. [$(getMeta toc "$f")]($(basename ${f%.*}).html)" >> $FILE;
        done
        ;; #}}}
    *random*)     # randomize.js: compile.sh randomize.js *.html #{{{
        rlist=$(echo "$@" | sed -e 's/\(\S\+.html\) \?/"\1",/g' \
                                -e 's/^\(.*\),$/var files=[\1]/')
        sed -i "s/var files=.*/$rlist/" $FILE;
        ;; #}}}
    --fix-head)   # fix backlink head: compile.sh --fix-head a.back a.txt #{{{
        title="$(getMeta toc "$2")";
        id="$(getMeta id "$2")";
        sed -i "s/__TITLE__/$title/" "$1";
        sed -i "s/__ID__/$id/" "$1";
        ;; #}}}
    *)            # bad argument {{{
        echo "Bad argument";
        exit 1;
        ;; #}}}
esac

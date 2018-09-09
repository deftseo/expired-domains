#!/usr/bin/env bash
CUR_DIR=`pwd`
BIN_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BASE_DIR="$( dirname $BIN_DIR )"

OUTPUT_DIR="$BASE_DIR/data"
MIN_FILE_SIZE=25000

TODAY=`date +%Y-%m-%d`

# START_DATE="2006-01-01"
# END_DATE="2017-12-31"

START_DATE="2018-06-01"
# END_DATE="2018-08-31"

END_DATE=$TODAY

TLD="com"

# Create output dir if it doesn't already exist
if [[ ! -d $OUTPUT_DIR ]]; then
    mkdir -p $OUTPUT_DIR
fi

read Y M D <<<  ${END_DATE//[-: ]/ }
END_DATE_CMP="$Y$M$D"

read Y M D <<<  ${START_DATE//[-: ]/ }
START_DATE_CMP="$Y$M$D"

CUR_DATE=$START_DATE
CUR_DATE_CMP=$START_DATE_CMP
CUR_YEAR="$Y"

while [ $CUR_DATE_CMP -le $END_DATE_CMP ]; do
    JUST_DATE=`date -d "$CUR_DATE" +%m%d%y`
    JUST_URL="https://justdropped.com/drops/${JUST_DATE}com.html"

    FILE_PATH="$OUTPUT_DIR/${TLD}-${CUR_YEAR}"
    FILE_NAME="${FILE_PATH}/${CUR_DATE}.html"
    GET_FILE=false

    echo "Date: $CUR_DATE => $FILE_DATE"
    # echo "Date: $CUR_DATE => $FILE_DATE"
    # echo "From: $JUST_URL"
    # echo "To: $FILE_NAME"

    # Create year directory if not created
    if [[ ! -d $FILE_PATH ]]; then
        echo "Creating directory $FILE_PATH"
        mkdir -p $FILE_PATH
    fi

    if [[ ! -f $FILE_NAME ]]; then
        echo "$CUR_DATE: From $JUST_URL"
        wget -O $FILE_NAME $JUST_URL

        FILE_SIZE=$(wc -c <"$FILE_NAME")
        if [ $FILE_SIZE -le $MIN_FILE_SIZE ]; then
            echo "Too small! ($FILE_SIZE). Deleting."
            rm $FILE_NAME

        else
            # Extract domain list from the file
            sed -i -e '/^[a-z0-9-]\+\.[a-z]\{2,\}\(<br>\)\?$/!d' -e 's/<br>//' $FILE_NAME

        fi

        sleep 5

    fi

    # set up for next iteration
    CUR_DATE=`date -d "$CUR_DATE 1 day" +%Y-%m-%d`
    CUR_DATE_CMP=`date -d "$CUR_DATE" +%Y%m%d`
    CUR_YEAR=`date -d "$CUR_DATE" +%Y`
done

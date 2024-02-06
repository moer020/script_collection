#!/bin/bash
######################
#
#  Autor:   moer020
#  Version: 06052022
#
######################

# Variablen
DEPLOY_DIR=./db/deploy
UNDEPLOY_DIR=./db/undeploy
LOG_OUT_DIR=./logs

create_temp_log_dir () {
        LOGDIR=$LOG_OUT_DIR/run_$(date +%Y%m%d%H%M)
        mkdir -p $LOGDIR
        echo "Logverzeichnis: $LOGDIR"
}
deploy () {
        create_temp_log_dir
        for file in $DEPLOY_DIR/*
        do
                #echo s+ -u --ifile $file --ofile
                USER=$(basename ${file} | awk -F'[.]' '{print $2}')
                USER=$(echo "$USER" | tr '[:lower:]' '[:upper:]')
                echo "s+ --silent -u $USER --ifile $file --ofile $LOGDIR/$(basename ${file} .sql).out"
                #/DBA/nest/oracle/bin/s+ --silent -u $USER --ifile $file --ofile $LOGDIR/$(basename ${file} .sql).out
                if [ $? -gt 0 ]
                then
                        exit;
                fi
        done
}

undeploy () {
        create_temp_log_dir
        for file in $UNDEPLOY_DIR/*
        do
                #echo s+ -u --ifile $file --ofile
                USER=$(basename ${file} | awk -F'[.]' '{print $2}')
                USER=$(echo "$USER" | tr '[:lower:]' '[:upper:]')
                echo "s+ --silent -u $USER --ifile $file --ofile $LOGDIR/$(basename ${file} .sql).out"
                #/DBA/nest/oracle/bin/s+ --silent -u $USER --ifile $file --ofile $LOGDIR/$(basename ${file} .sql).out
                if [ $? -gt 0 ]
                then
                        exit;
                fi
        done
}


# Auswerten der Optionen
while [ -n "$1" ]; do
        case "$1" in
        -m)
                case "$2" in
                deploy)
                        deploy ;;
                undeploy)
                        undeploy ;;
                *)
                        echo "Mode nicht bekannt" ;;
                esac

                shift
                ;;

        *) echo "Option $1 not recognized" ;;
        esac
        shift
done

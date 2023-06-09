if [ $# -lt 3 ]; then
        echo "Usage: $0 url_format seq_start seq_end [wget_args]"
        exit
fi

url_format=$1
seq_start=$2
seq_end=$3
shift 3

printf "$url_format\\n" `seq $seq_start $seq_end` | wget -i- "$@"

SAFETY_MARGIN=$(( 10 * 1024 * 1024 )) # in bytes

DELIVERED_DIR=`dirname "$DELIVERY_PATH"`

FREE_BYTES=`run_remote "df -k \"$DELIVERED_DIR\""`
# | awk '/[0-9]%/{print $(NF-2)*1024}'`
echo "FREE $FREE_BYTES"

NECESSARY_BYTES=$(( `git archive --format=tar $VERSION | wc -c` + $SAFETY_MARGIN ))
#TODO: ajouter la taille du diff entre le .git de la remote (donc toute la remote sauf le delivered) et le .git a livrer ?

AWK_FORMAT='{x = $0
             split("B KB MB GB TB PB", type)
             for(i=5;y < 1;i--)
                 y = x / (2**(10*i))
             print y type[i+2]
             }'

HUMAN_FREE_BYTES=`echo "$FREE_BYTES" | awk "$AWK_FORMAT"`
HUMAN_NECESSARY_BYTES=`echo "$NECESSARY_BYTES" | awk "$AWK_FORMAT"`

echo "Delivery will require $HUMAN_NECESSARY_BYTES on remote, $HUMAN_FREE_BYTES available"

#[[ $FREE_BYTES -gt $NECESSARY_BYTES ]] || ( echo "Not enough disk space abvailable on remote" ; exit 1 )

#exit 0

#!/bin/bash

# https://github.com/muvment/waybar-monero

# Your wallet address
address=""

# Main account balance
main=""

# Currency to be used with localmonero query (can be USD, EUR, GBP or HKD)
currency=""

# Currency symbol to use in display ($, £, €, etc...)
symbol=""

# Crypto symbols
## Monero
m=""
## Other cryptos to show (choose the ones you want)
s1=""
s2=""

# Fetch p2pool balance, unquote the correct one (first is main, second is mini)
#p2pool=$(curl -sS "https://p2pool.observer/payouts/$address"  | grep -Po '(?<=<p><strong>Estimated total:</strong>).*?(?<=XMR</p>)' | awk '{print $1}')
#p2pool=$(curl -sS "https://mini.p2pool.observer/payouts/$address" | grep -Po '(?<=<p><strong>Estimated total:</strong>).*?(?<=XMR</p>)' | awk '{print $1}')

# Fetch xmrvsbeast raffle bonus balance
xmrvsbeast=$(curl -sS "https://p2pool.observer/payouts/$address" \
    | grep -Po '(?<=<p><strong>Estimated total:</strong>).*?(?<=XMR</p>)' | awk '{print $1}')

# P2pool total balance
p2p_total=$(awk "BEGIN{print($p2pool + $xmrvsbeast)}")

# Total sum of main and p2pool wallets together (to be added)
total=$(awk "BEGIN{print($main + $p2p_total)}")

# Localmonero url to fetch current market street exchange prices
lm_url="https://localmonero.co/web/ticker?currencyCode=$currency"

# Fetch p2pool total number of payouts
mpn=$(curl -sS "https://mini.p2pool.observer/api/payouts/$address?search_limit=0" | jq -c '.[]' | wc -l)
pn=$(curl -sS "https://p2pool.observer/api/payouts/$address?search_limit=0" | jq -c '.[]' | wc -l)
if [[ "$mpn" == "1" ]]; then
p2p_pn="$pn"
else
p2p_pn=$(awk "BEGIN{print($mpn + $pn)}")
fi

# Fetch localmonero info and format output to the desired display pattern
lm=$(curl -sS "$lm_url" | jq -M '. [] | .avg_6h, .avg_12h, .avg_24h' \
    | sed "1 s/.*/6h: &/;2 s/.*/12h: &/;3 s/.*/24h: &/;s/.*/&$symbol/")
LM1=$(echo "$lm" | awk 'FNR == 1 {print $1, $2, $3}')
LM2=$(echo "$lm" | awk 'FNR == 2 {print $1, $2, $3}')
LM3=$(echo "$lm" | awk 'FNR == 3 {print $1, $2, $3}')

# Collect info for the currency tickers we wish to display in the tooltip
MAIN=$(rates -s $main XMR $currency)
P2POOL=$(rates -s "$p2p_total" XMR $currency)
TOTAL=$(rates -s "$total" XMR $currency)
XMR=$(rates -s 1 XMR $currency)
LTC=$(rates -s 1 LTC $currency)
BTC=$(rates -s 1 BTC $currency)

case $1 in
    w)
    # Format of the tooltip display
    tooltip="Main:\n${m} ${MAIN}${symbol}\nP2pool:\n${m} ${P2POOL}${symbol}\nTotal:\n${m} ${TOTAL}${symbol}\nP2pool payouts:\n${p2p_pn}\nLocalmonero:\n${LM1}\n${LM2}\n${LM3}\nRates:\n${m} ${XMR}${symbol}\n${s1} ${LTC}${symbol}\n${s2} ${BTC}${symbol}\n"

    # Info to be sent to waybar
    echo "{\"text\": \"${m} ${TOTAL}\", \"tooltip\": \"<tt>${tooltip}</tt>\", \"class\": \"crypto\"}"
    ;;
    t)
    # Display in terminal
    echo -e "Main:\n${m} ${MAIN}${symbol}\nP2pool:\n${m} ${P2POOL}${symbol}\nTotal:\n${m} ${TOTAL}${symbol}\nP2pool payouts:\n${p2p_pn}\nLocalmonero:\n${LM1}\n${LM2}\n${LM3}\nRates:\n${m} ${XMR}${symbol}\n${s1} ${LTC}${symbol}\n${s2} ${BTC}${symbol}\n"
esac

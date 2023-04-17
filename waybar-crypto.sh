#!/bin/bash

# https://github.com/muvment/waybar-monero
# Can use either of these ids to get the info from p2pool or mini.p2pool API. MAKE SURE YOU USE YOUR WALLET ID IF YOU'RE NOT QUERING YOUR ACTUAL POOL!!
# Otherwise, you'll get someone else's data
miner_id=""
wallet_id=""

# Main account balance
main=""

# Fetch mini.p2pool balance
mini_p2pool=$(curl -sS "https://mini.p2pool.observer/payouts/$miner_id" \
    | grep -Po '(?<=<p><strong>Estimated total:</strong>).*?(?<=XMR</p>)' | awk '{print $1}')

# Fetch p2pool balance (for xmrvsbeast raffle bonus balance)
p2pool=$(curl -sS "https://p2pool.observer/payouts/$wallet_id" \
    | grep -Po '(?<=<p><strong>Estimated total:</strong>).*?(?<=XMR</p>)' | awk '{print $1}')

# P2pool total balance (to be added)
p2p_total=$(awk "BEGIN{print($mini_p2pool + $p2pool)}")

# Total sum of main and p2pool wallets together (to be added)
total=$(awk "BEGIN{print($main + $p2p_total)}")

# Currency to be used with localmonero query (can be USD, EUR, GBP or HKD)
currency="USD"

# Localmonero url to fetch current market street exchange prices
lm_url="https://localmonero.co/web/ticker?currencyCode=$currency"

# Fetch p2pool total number of payouts
p2p_pn=$(curl -sS "https://mini.p2pool.observer/api/payouts/$miner_id?search_limit=0" | jq -c '.[]' | wc -l)

# Fetch localmonero info and format output to the desired display pattern
lm=$(curl -sS "$lm_url" | jq -M '. [] | .avg_6h, .avg_12h, .avg_24h' \
    | sed '1 s/.*/6h: &/;2 s/.*/12h: &/;3 s/.*/24h: &/;s/.*/&$/')
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
    #tooltip="Owned:\n $OWNED$\nRates:\n $XMR$\n $LTC$\n $BTC$\n"
    tooltip="Main:\n $MAIN$\nP2pool:\n $P2POOL$\nTotal:\n $TOTAL$\nP2pool payouts:\n$p2p_pn\nLocalmonero:\n$LM1\n$LM2\n$LM3\nRates:\n $XMR$\n $LTC$\n $BTC$\n"

    # Info to be sent to waybar
    echo "{\"text\": \" $TOTAL\", \"tooltip\": \"<tt>$tooltip</tt>\", \"class\": \"crypto\"}"
    ;;
    t)
    # Display in terminal
    echo -e "Main:\n $MAIN$\nP2pool:\n $P2POOL$\nTotal:\n $TOTAL$\nP2pool payouts:\n$p2p_pn\nLocalmonero:\n$LM1\n$LM2\n$LM3\nRates:\n $XMR$\n $LTC$\n $BTC$\n"
esac

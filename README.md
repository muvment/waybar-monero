# waybar-monero ![](https://www.getmonero.org/meta/favicon-32x32.png)

## Monero &amp; P2pool ticker for waybar (and terminal)

<img src="example/example.png" align="right" width="125px"/>

For a fast overview of your XMR and P2pool stats, without having to open the wallet and wait for it to sync.

It also can get your [xmrvsbeast](https://xmrvsbeast.com/p2pool/) stats.

## Dependencies:
- You'll need some kind of crypto font; e.g. [cryptocoins](https://github.com/AllienWorks/cryptocoins/blob/master/webfont/cryptocoins.ttf), [wp-cryptofonts](https://github.com/evgrezanov/wp-cryptofonts/blob/5e598eba70798f20af6970e3c256ff06cbfe88a9/asset/fonts/cryptofont.ttf), [crypto-icons](https://github.com/guardaco/crypto-icons/blob/3f0ddf1352afe40269e4519c4cde6ed4a60a7350/fonts/coins.ttf)...
- [Rates](https://github.com/lunush/rates), to convert to your favourite fiat currency
- [Waybar](https://github.com/Alexays/Waybar) (haven't tested with others like polybar, but it should be easy enough to modify it for it)

The rest is done using [P2pool's observer](https://p2pool.observer/api) API and some minimal, direct scraping of the website; and [Localmonero's](https://localmonero.co/web/ticker?currencyCode=USD) API (can be USD, GBP, EUR or HKD).
<br clear="right"/>

## Installation

1. Download or clone this repo and put [waybar-crypto.sh](https://github.com/muvment/waybar-monero/raw/main/waybar-crypto.sh) in `~/.config/waybar/scripts/` for example

- With curl
```
# Make directory if needed
mkdir ~/.config/waybar/scripts

# Download the script
curl -LJO 'https://github.com/muvment/waybar-monero/raw/main/waybar-crypto.sh'

# Copy the script into your scripts folder
mv waybar-crypto.sh ~/.config/waybar/scripts

# Make it executable
chmod +x ~/.config/waybar/scripts/waybar-crypto.sh
```

- With git
```
# Make directory if needed
mkdir ~/.config/waybar/scripts

# Clone the repo
git clone https://github.com/muvment/waybar-monero

# cd into the cloned folder
cd waybar-monero

# Copy the script into your scripts folder
cp waybar-crypto.sh ~/.config/waybar/scripts

# Make it executable
chmod +x ~/.config/waybar/scripts/waybar-crypto.sh
cd
```
2. If you haven't already, get your miner ID (replace `address` with your mining wallet address) and copy it
```
# Main
curl -sS "https://p2pool.observer/api/miner_info/address" | jq '.'
# Mini
curl -sS "https://mini.p2pool.observer/api/miner_info/address" | jq '.'
```

3. Open `~/.config/waybar/scripts/waybar-crypto.sh` in your editor and modify the following
```
# Your mining ID (paste your mining ID here)
miner_id=""

# If you're mining on the mini.p2pool chain and you're registered
# in the "https://xmrvsbeast.com/p2pool" raffle, you need
# to replace "0" with your wallet id
wallet_id="0"

# Main account balance (put your personal/primary account balance in XMR here)
main=""

# Currency to be used with localmonero query (can be USD, EUR, GBP or HKD)
currency=""

# Currency symbol to use in display ($, £, €, etc...)
symbol=""

## Fetch p2pool balance, unquote the correct one (first is main, second is mini)
#p2pool=$(curl -sS "https://p2pool.observer/payouts/$miner_id"  | grep -Po '(?<=<p><strong>Estimated total:</strong>).*?(?<=XMR</p>)' | awk '{print $1}')
#p2pool=$(curl -sS "https://mini.p2pool.observer/payouts/$miner_id" | grep -Po '(?<=<p><strong>Estimated total:</strong>).*?(?<=XMR</p>)' | awk '{print $1}')
```
4. In your `~/.config/waybar/config` (you can change the interval to whatever you want, but remember you're using public APIs so don't abuse them)
```    
"custom/crypto": {
    "format": "",
    "return-type": "json",
    "format-alt": "{}",
    "interval": 3600,
    "exec": "$HOME/.config/waybar/scripts/waybar-crypto.sh w",
    "tooltip":true
    },
```
5. Download/clone needed fonts, my fonts of choice are [wp-cryptofonts](https://github.com/evgrezanov/wp-cryptofonts/raw/main/asset/fonts/cryptofont.ttf). In my system, I have them in `~/.local/share/fonts`
```
# Download the fonts
curl -LJO 'https://github.com/evgrezanov/wp-cryptofonts/raw/main/asset/fonts/cryptofont.ttf'
# Copy them to your fonts folder
cp cryptofont.ttf ~/.local/share/fonts
# Reload font cache
sudo fc-cache -f -v
```
6. Reload your waybar config

Alternatively, if you plan to use it in your terminal, put it somewhere in your path (MAKE SURE you've exported any of these to your `$PATH` beforehand), e.g. `~/.local/bin/` or `~/bin/` and change or alias the name of the script to something shorter, like 'xmrp2p' (idk, up to you).


## Usage
```
# Waybar output
./waybar-monero.sh w
# Terminal output
./waybar-monero.sh t
```


## Preview

![](example/example.gif)

I don' drink coffee.

XMR: 83DP8YWimcZBsGkgdegsvRdARa94LoYXeeBjFbbdrQNzMcBw9N7kpyZbydL9iGA9Sc8G1dx42A1bHPvQsmTo5UVj7buwVEm


# waybar-monero ![](https://www.getmonero.org/meta/favicon-32x32.png)

## Monero &amp; P2pool ticker for waybar (and terminal)

<img src="example/example.png" align="right" width="125px"/>
Couldn't find any other monero-only, detailed crypto ticker for either waybar, polybar, etc...

So, made one.

Opening the wallet, syncing and checking everytime is a bit tedious, this makes it fast, easy, and customizable.

Dependencies:
- You'll need some kind of crypto font; e.g. [`cryptocoins`](https://github.com/AllienWorks/cryptocoins/blob/master/webfont/cryptocoins.ttf), [`wp-cryptofonts`](https://github.com/evgrezanov/wp-cryptofonts/blob/5e598eba70798f20af6970e3c256ff06cbfe88a9/asset/fonts/cryptofont.ttf), [`crypto-icons`](https://github.com/guardaco/crypto-icons/blob/3f0ddf1352afe40269e4519c4cde6ed4a60a7350/fonts/coins.ttf)...
- [`Rates`](https://github.com/lunush/rates), to convert to your favourite fiat currency
- [`Waybar`](https://github.com/Alexays/Waybar) (haven't tested with others like polybar, but it should be easy enough to modify it for it)

The rest is done using [`P2pool's observer`](https://p2pool.observer/api) api and some minimal, direct scraping of the website and [`Localmonero's`](https://localmonero.co/web/ticker?currencyCode=USD) api (can be USD, GBP, EUR or HKD).
<br clear="right"/>

# Installation

1. Download or clone this repo, or copy/paste the contents of [`waybar-crypto.sh`](https://github.com/muvment/waybar-monero/raw/main/waybar-crypto.sh) in your editor and put it in `~/.config/waybar/scripts/` for example.

```
# Make directory if needed
mkdir ~/.config/waybar/scripts
# Clone the repo
git clone https://github.com/muvment/waybar-monero
# cd into the cloned folder
cd waybar-monero
# Copy the script into your scripts folder
cp waybar-crypto.sh ~/.config/waybar/scripts
cd
# Make it executable
chmod +x ~/.config/waybar/scripts/waybar-crypto.sh
```
2. In your waybar config (`~/.config/waybar/config`). You can change `"interval":` to whatever you want, but remember you're using public APIs so don't over task them. Remember to add `"custom/crypto"` in you `"modules-right: []"` (or modules-left or center), and don't forget to add a coma `,` after it if it's not the last of the modules list.

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
3. Download/clone needed fonts, my fonts of choice are [`wp-cryptofonts`](https://github.com/evgrezanov/wp-cryptofonts/blob/5e598eba70798f20af6970e3c256ff06cbfe88a9/asset/fonts/cryptofont.ttf). In my system, I have them in `~/.local/share/fonts`.

```
# Download the fonts
curl -LJO 'https://github.com/evgrezanov/wp-cryptofonts/blob/5e598eba70798f20af6970e3c256ff06cbfe88a9/asset/fonts/cryptofont.ttf?raw=true'
# Copy them to your fonts folder
cp cryptofont.ttf ~/.local/share/fonts
# Reload font cache
sudo fc-cache -f -v
```

4. Reload your waybar config.

Alternatively, if you plan to use it in your terminal, put it somewhere in your path (MAKE SURE you've exported any of these to your `$PATH` beforehand), e.g. `~/.local/bin/` or `~/bin/` and change or alias the name of the script to something shorter, like 'xmrp2p' (idk, up to you).

## Usage

```
# Waybar output
./waybar-monero.sh w
# Terminal output
./waybar-monero.sh t
```

# Preview

![](example/example.gif)

I don' drink coffee.

XMR: 83DP8YWimcZBsGkgdegsvRdARa94LoYXeeBjFbbdrQNzMcBw9N7kpyZbydL9iGA9Sc8G1dx42A1bHPvQsmTo5UVj7buwVEm

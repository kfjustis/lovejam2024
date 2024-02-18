# Description
Made for Love Jam 2024 with Love 11.5!

# Libraries used
* [Breezefield](https://github.com/HDictus/breezefield) (commit: [ae05a58](https://github.com/HDictus/breezefield/commit/ae05a587e5549163bda817111621594cdcb5a7db), License: MIT)

* [Classic](https://github.com/rxi/classic/) (commit: [e561075](https://github.com/rxi/classic/commit/e5610756c98ac2f8facd7ab90c94e1a097ecd2c6), License: MIT)

* [Hump.gamestate](https://github.com/HDictus/hump) (commit: [0029de0](https://github.com/HDictus/hump/commit/0029de08a0d3339ecc910af4a19eef89538f0972), License: Custom)

* [Push](https://github.com/Ulydev/push) (commit: [9c16581](https://github.com/Ulydev/push/commit/9c165816a14c868339c3cd0d22eed65c313c8bf8), License: MIT)

# Quick Web Build
```
// more info: https://github.com/pfirsich/makelove
makelove lovejs
```

# Custom Web Build
```
npx love.js.cmd [options] <input> <output>

// more info: https://github.com/Davidobot/love.js
// -c runs single threaded if need be. avoids sharedarraybuffer issues.
npx love.js.cmd lovejam2024.love build -c
```
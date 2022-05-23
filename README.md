# .qoi thumbnailer for nemo

## how to install
1. clone this repo
```sh
git clone https://github.com/walksanatora/qoi-thumbnailer-nemo
```
2. `cd qoi-thumbnailer-nemo`
3. build the apt packages
```sh
./build.sh
```
4. install the `qoi-thumbnailer` and `qoiconv` packages

if thumbnails do not show up try
```sh
rm -rfv ~/.cache/thumbnails
<file explorer> -q # fully quits the file explorer so it can search for new thumbnailers
```
and re-open your file explorer

## Thanks
to this stackoverflow question
[https://askubuntu.com/questions/1368910/how-to-create-custom-thumbnailers-for-nautilus-nemo-and-caja](https://askubuntu.com/questions/1368910/how-to-create-custom-thumbnailers-for-nautilus-nemo-and-caja)
phoboslab for the qoi format and `qoiconv` program
[https://github.com/phoboslab/qoi](https://github.com/phoboslab/qoi)
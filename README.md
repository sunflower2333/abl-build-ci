# Build ABL image in workflow

## Prepare
- Clone this repo
```bash
git clone --depth=1 https://github.com/sunflower2333/abl-build-ci/
git submodule update --init
```

- Install those packages
    + On Ubuntu 22.04
    ```bash
    sudo apt-get update
    sudo apt-get install -y  gcc-aarch64-linux-gnu clang uuid-dev libtinfo5
    ```
    + On Ubuntu 24.04
    ```bash
    sudo apt-get update
    sudo apt-get install -y  gcc-aarch64-linux-gnu clang uuid-dev wget
    wget http://security.ubuntu.com/ubuntu/pool/universe/n/ncurses/libtinfo5_6.3-2ubuntu0.1_amd64.deb
    sudo apt install ./libtinfo5_6.3-2ubuntu0.1_amd64.deb
    rm libtinfo5_6.3-2ubuntu0.1_amd64.deb
    ```

- Install sectools dependence
```bash
pip install -r sectools/qtestsign/requirements.txt
```

> [!NOTE]  
> If you meet error while `pip install`, please create  
> a python virtual environment and activate it.  

## Build
Run the following command to build abl for specific target.
Refer to supported target table for reference.
```bash
./build.sh <abl-dir> <patch-dir> <target> <sec_version>
```

## Supported targets
| abl-dir       | patch-dir         | target    |
|---------------|-------------------|-----------|
| abl-pineapple | patch-pineapple   | pineapple |
| abl-pineapple | patch-pineapple   | kailua    |
| abl-pineapple | patch-pineapple   | waipio    |
| abl-pineapple | patch-pineapple   | sun       |

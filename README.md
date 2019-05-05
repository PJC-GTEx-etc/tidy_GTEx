Tidy GTEx
================
Joshua Cook
2019-05-05

## Git Large File Storage

This repository uses git large file storage (“git-lfs”) in order to
manage the large data files.

### Installation

The instructions on installing git-lfs for Mac, Windows, and some linux
distros are available on the [git-lfs GitHub repo
Wiki](https://github.com/git-lfs/git-lfs/wiki/Installation#source).
Since I did this work remotely on the HMS Research Computing Cluster, I
do not have root access and had to install from source.

1.  Download the source code of the latest release from
    [here](https://github.com/git-lfs/git-lfs/releases/latest).

<!-- end list -->

``` bash
wget https://github.com/git-lfs/git-lfs/releases/download/v2.7.2/git-lfs-v2.7.2.tar.gz
```

2.  Build the binary using `go build -o /path/to/dest/git-lfs`, where
    `/path/to/dest/git-lfs` is the name of the directory you store your
    installed software in. For instance, I used `~/bin/git-lfs`.

<!-- end list -->

``` bash
module load go
go build -o ~/bin/git-lfs
```

There should now be a file with the same path and name that you passed
using the `-o` flag.

3.  Set up git-lfs in your git repository.

<!-- end list -->

``` bash
cd /path/to/my/git/repo
git lfs install
#> Updated git hooks.
#> Git LFS initialized.
```

4.  Declare which files to track.

<!-- end list -->

``` bash
git lfs track "*.bigfiles"
#> Tracking "really_big_file.bigfiles"
#> Tracking "so_big_such_wow.bigfiles"
#> Tracking "large_files_rock.bigfiles"
```

where `"*.bigfiles"` is the regular expression for large files in the
repo.

5.  Track “.gitattributes”.

<!-- end list -->

``` bash
git add .gitattributes
git commit .gitattributes -m "start git-lfs"
```

You should now be able to add, commit, and push files like normal. Steps
1 and 2 only need to be done once per machine. Steps 3-5 need to be
completed once per repository.

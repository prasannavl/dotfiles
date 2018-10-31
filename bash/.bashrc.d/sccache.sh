# sccache for rustc
if [ $(command -v sccache) ]; then
    export RUSTC_WRAPPER=sccache
fi
#!/bin/bash
set -x
usage() {
    echo "Usage:"
    echo "  Mode 1: $0 --verilog-file-path <path> OR $0 --preset-json <path>"
    echo "  Mode 2: $0 --c-file-path <path>"
    exit 1
}

VERILOG_PATH=""
PRESET_PATH=""
C_PATH=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --verilog-file-path)
            VERILOG_PATH="$2"
            shift 2
            ;;
        --preset-json)
            PRESET_PATH="$2"
            shift 2
            ;;
        --c-file-path)
            C_PATH="$2"
            shift 2
            ;;
        *)
            usage
            ;;
    esac
done

if [ -n "$VERILOG_PATH" ] && [ -n "$PRESET_PATH" ]; then
    echo "Error: Cannot use both --verilog-file-path and --preset-json"
    exit 1
fi

if [ -n "$C_PATH" ] && ([ -n "$VERILOG_PATH" ] || [ -n "$PRESET_PATH" ]); then
    echo "Error: Cannot combine Mode 1 and Mode 2 options"
    exit 1
fi

if [ -n "$VERILOG_PATH" ]; then
    echo "Verilog file: $VERILOG_PATH"
    cat $VERILOG_PATH
    cd Vivado
    ./synth.sh
elif [ -n "$PRESET_PATH" ]; then
    echo "Preset JSON: $PRESET_PATH"
    cat $PRESET_PATH
elif [ -n "$C_PATH" ]; then
    echo "C file: $C_PATH"
    cat $C_PATH
    cd Vitis && ./compile_run.sh
else
    usage
fi

#/bin/bash

#a tool to get all the jucy details out of nvidia-settings and into a usable shell format

# if you want to add your own (or something is broken, I only have so much to test with) 
# run "nvidia-settings -q all" to find all searchable attributes

#                    -q [gpu:0]/GPUCoreTemp \
#                    -q [gpu:0]/GPUUtilization \
#                    -q [gpu:0]/TotalDedicatedGPUMemory \
#                    -q [gpu:0]/UsedDedicatedGPUMemory \
#                    -q [gpu:0]/GPUCurrentClockFreqs \
#                    -q [gpu:0]/VideoEncoderUtilization \
#                    -q [gpu:0]/VideoDecoderUtilization \

get_nv_attr() 
{
    echo $(nvidia-settings -t  -q [gpu:0]/$1)
}


#GPUCoreTemp=$(get_nv_attr GPUCoreTemp)
#GPUUtilization=$(get_nv_attr GPUUtilization)
#TotalDedicatedGPUMemory=$(get_nv_attr TotalDedicatedGPUMemory)
#UsedDedicatedGPUMemory=$(get_nv_attr UsedDedicatedGPUMemory)
#GPUCurrentClockFreqs=$(get_nv_attr GPUCurrentClockFreqs)
#VideoEncoderUtilization=$(get_nv_attr VideoEncoderUtilization)
#VideoDecoderUtilization=$(get_nv_attr VideoDecoderUtilization)

split_nv_usage()
{
    #graphics=0, memory=0, video=0, PCIe=0
    python -c "print '${GPUUtilization}'.split()[$1].split('=')[1].replace(',','')"
}

if [[ $1 == "GRAM" ]]; then
    #python -c "print('%0.0f'%((${UsedDedicatedGPUMemory}.0/${TotalDedicatedGPUMemory}.0)*100))"
    nvidia-smi | python -c "import sys;smi= sys.stdin.read();data_line = smi.split('\n')[8];_,temp,ram,_,_= data_line.split('|');print ram.strip().replace(' ','').replace('MiB','')"
    #echo N/A
elif [[ $1 == "GUSAGE" ]]; then
    #split_nv_usage 0
    echo N/A
#elif [[ $1 == "GBUS" ]]; then
#    split_nv_usage 3
elif [[ $1 == "GTMP" ]]; then
    #echo N/A
    nvidia-smi | python -c "import sys;smi= sys.stdin.read();data_line = smi.split('\n')[8];_,temp,ram,_,_= data_line.split('|');print temp.split()[1]"
fi

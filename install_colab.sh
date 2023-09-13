JULIA_VERSION="1.9.3"
if [ -z `which julia` ]; then
  # Install Julia
  JULIA_VER=`cut -d '.' -f -2 <<< "$JULIA_VERSION"`
  echo "Installing Julia $JULIA_VERSION on the current Colab Runtime..."
  BASE_URL="https://julialang-s3.julialang.org/bin/linux/x64"
  URL="$BASE_URL/$JULIA_VER/julia-$JULIA_VERSION-linux-x86_64.tar.gz"
  wget -nv $URL -O /tmp/julia.tar.gz
  tar -x -f /tmp/julia.tar.gz -C /usr/local --strip-components 1
  rm /tmp/julia.tar.gz
  # Install kernel and rename it to "julia"
  echo "Installing IJulia..."
  julia -e 'import Pkg; Pkg.add("IJulia"); Pkg.precompile();' &> /dev/null
  echo "Installing kernel..."
  julia -e 'import IJulia; IJulia.installkernel("julia"; env = Dict("JULIA_NUM_THREADS" => "4"))' &> /dev/null
  KERNEL_DIR=`julia -e 'import IJulia; print(IJulia.kerneldir())'`
  KERNEL_NAME=`ls -d "$KERNEL_DIR"/julia*`
  mv -f $KERNEL_NAME "$KERNEL_DIR"/Julia-1.9  
  echo ''
  echo "Successfully installed `julia -v`!"
  echo "Please reload this page (press Ctrl+R, ⌘+R, or the F5 key)"
fi

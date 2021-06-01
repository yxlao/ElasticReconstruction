# Configure indoor-executables-1.1 on Windows 10

## Get dataset

Put `input.oni` in sandbox/
E.g. download from:
https://github.com/yxlao/ElasticReconstruction/releases/download/bin/input.oni.

## Get MS Visual C++ 2010 runtime (`vcomp100.dll`)

`vcomp100.dll` has already been copied to `indoor-executables-1.1\bin`. Skip
this step if it works.

- Get it from: http://www.microsoft.com/download/details.aspx?id=26999.
- Also see: https://support.microsoft.com/en-us/topic/.the-latest-supported-visual-c-downloads-2647da03-1eea-4433-9aff-95f26a218cc0.
- After inttallation, it will be in `C:\Windows\System32\vcomp100.dll`.

## Get CUDA 7.0 (`curand64_70.dll`)

`curand64_70.dll` has already been copied to `indoor-executables-1.1\bin`. Skip
this step if it works.

- Download from: https://developer.nvidia.com/cuda-toolkit-70
- Direct link: http://developer.download.nvidia.com/compute/cuda/7_0/Prod/local_installers/cuda_7.0.28_windows.exe
- Extract the `.dll` file:
  1. Run the installer.
  2. It will ask for the path to extract the files, typically it is
     `%USERPROFILE%\AppData\Local\Temp\CUDA`
  3. Go to `%USERPROFILE%\AppData\Local\Temp\CUDA\CUDAToolkit\bin`.
  4. Copy `curand64_70.dll` to `indoor-executables-1.1\bin`.
  5. Close the installer. You don't need to install it.

## Get OpenNI library (`OpenNI64.dll`)

`OpenNI64.dll` has already been copied to `indoor-executables-1.1\bin`. Skip
this step if it works.

- Install [OpenNI 1.5.4](http://redwood-data.org/indoor/data/OpenNI-Win64-1.5.4-Dev.msi).
- Copy `C:\Program Files\OpenNI\Bin64\OpenNI64.dll` to `indoor-executables-1.1\bin`.

## Get a bash shell

You can get a bash shell by installing [Git for Windows](https://git-scm.com/download/win).

If you're using
[Windows Terminal](https://www.microsoft.com/en-us/p/windows-terminal/9n0dx20hk701),
add the following profile to the settings.

```json
// https://github.com/microsoft/terminal/issues/10290
{
    "backgroundImage": null,
    "commandline": "C:\\Program Files\\Git\\bin\\bash.exe -li",
    "icon": "C:\\Program Files\\Git\\mingw64\\share\\git\\git-for-windows.ico",
    "name": "Git-Bash",
    "scrollbarState": "visible",
    "startingDirectory": "D:\\AppDev\\Github",
    "useAcrylic": false
}
```

## Run test scripts

Using the bash shell, go to `indoor-executables-1.1/bin`. If everything goes
correct, this shall work:

```bash
./test.sh
```

You shall see all commands being executed sucessfully. They shall not complain
about missing `.dll`. They will complain about missing parameters, which is
expected.

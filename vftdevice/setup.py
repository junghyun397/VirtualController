# noinspection PyUnresolvedReferences
from cx_Freeze import setup, Executable

buildOptions = dict(packages=["pyvjoy"])

exe = [Executable("vft_device_server_windows.py")]

setup(
    name="VFT-device-server",
    version="0.1",
    author="JeongHyeon Choi",
    description="ola!",
    options=dict(build_exe=buildOptions),
    executables=exe,
)

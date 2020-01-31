# noinspection PyUnresolvedReferences
from cx_Freeze import setup, Executable

buildOptions = dict(packages=["pyvjoy"])

exe = [Executable(
    script="vft_device_server_windows.py",
    icon="vft_icon.ico",
)]

setup(
    name="VFT-device-server",
    version="0.1",
    author="JeongHyeon Choi",
    description="VFT device server",
    options=dict(build_exe=buildOptions),
    executables=exe,
)

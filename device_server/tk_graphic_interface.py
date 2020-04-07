import threading
import tkinter


class TkGraphicInterface:

    def __init__(self):
        self._thread = None

    def start_ui(self):
        self._thread = threading.Thread(target=self._run_ui)
        self._thread.start()

    def kill_ui(self):
        self._thread.join()

    def _run_ui(self):
        window = tkinter.Tk()
        window.mainloop()

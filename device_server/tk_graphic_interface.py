# noinspection PyUnresolvedReferences
import threading
# noinspection PyUnresolvedReferences
import tkinter
# noinspection PyUnresolvedReferences
from tkinter import font
# noinspection PyUnresolvedReferences
from tkinter.scrolledtext import ScrolledText
# noinspection PyUnresolvedReferences
from typing import Tuple, Callable

MAX_LOGGER_ROW = 1000


class TkGraphicInterface:

    def __init__(self, on_stop=Callable[[None], None]):
        self._on_stop = on_stop

        self._thread = None

        self._ui_ready = False
        self._logger_buffer = list()

        self._window = None
        self._logger_widget = None

        self._connected = False
        self._client_name = False

    def start_ui(self):
        self._thread = threading.Thread(target=self._run_ui)
        self._thread.start()

    def kill_ui(self):
        self._window.destroy()
        self._window = None
        self._thread.join()

    def on_emit_log(self, message: str):
        if not self._ui_ready:
            self._logger_buffer.append(message)
        elif len(self._logger_buffer) > 0:
            self._logger_buffer.append(message)
            for x in self._logger_buffer:
                self._update_logger(x)
            self._logger_buffer.clear()
        else:
            self._update_logger(message)

    # noinspection PyTypeChecker
    def on_update_status(self, state: Tuple[bool, str]):
        if self._connected == state[0] or self._client_name == state[1]:
            pass

        self._update_status(state[0], state[1])

    def _run_ui(self):
        self._init_ui()
        self._window.mainloop()

    def _init_ui(self):
        self._window = tkinter.Tk()
        self._window.tk.call('tk', 'scaling', 4.0)
        self._window.title("VFT Device Server")
        self._window.geometry("600x400+100+100")

        print(font.families())

        head_label = tkinter.Label(self._window,
                                   text="VFT Device Server",
                                   font=font.Font(family="fixed", size=30),
                                   )
        head_label.grid(row=0, column=0)

        version_label = tkinter.Label(self._window,
                                      text="GUI version 1.0",
                                      )
        version_label.grid(row=0, column=1)

        self._logger_widget = ScrolledText(self._window,
                                           state="disabled",
                                           font="TkFixedFont",
                                           width=83,
                                           height=16,
                                           )
        self._logger_widget.place(x=0, y=200)

        self._ui_ready = True

        self.on_emit_log("[o] tkinter-ui ready.")

    def _update_status(self, connected: bool, client_name: str):
        pass

    def _update_logger(self, message: str):
        self._logger_widget.configure(state="normal")
        self._logger_widget.insert(tkinter.END, message + "\n")
        self._logger_widget.configure(state="disabled")
        self._logger_widget.yview(tkinter.END)

    def _stop_server(self):
        self.kill_ui()

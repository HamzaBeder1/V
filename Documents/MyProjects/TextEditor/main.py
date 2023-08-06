from tkinter import *
from tkinter import ttk

a = Tk()
files = ttk.Notebook(a)

def new_file():
    newFile = Frame(a)
    files.add(newFile, text = 'Untitled')
    horizontal_scroll = Scrollbar(newFile, width=30, orient=HORIZONTAL)
    vertical_scroll = Scrollbar(newFile, width=30, orient=VERTICAL)
    textbox = Text(newFile, xscrollcommand=horizontal_scroll.set, yscrollcommand=vertical_scroll.set, wrap="none")
    vertical_scroll.config(command=textbox.yview)
    horizontal_scroll.config(command=textbox.xview)

    horizontal_scroll.pack(fill=X, side=BOTTOM)
    vertical_scroll.pack(fill=Y, side=RIGHT)
    textbox.pack(fill=BOTH, expand=True)
    newFile.pack(fill=BOTH, expand=TRUE)
    files.pack(side=TOP)

def create_menu():
    toolbar = Menu(a)

    File = Menu(toolbar)
    Edit = Menu(toolbar)
    View = Menu(toolbar)
    toolbar.add_cascade(label='File', menu=File)
    toolbar.add_cascade(label='Edit', menu=Edit)
    toolbar.add_cascade(label='View', menu=View)
    File.add_command(label='New File', command=newFile)

    a.config(menu=toolbar)


def main():
    new_file()
    create_menu()
    a.mainloop()


if __name__ == "__main__":
    main()

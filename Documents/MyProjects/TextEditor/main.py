from tkinter import *
from tkinter import ttk
from tkinter import filedialog

windows = []
files = []
texts = []
def new_file():
    global windows
    global files
    newFile = Frame(files[len(files)-1])
    files[len(files)-1].add(newFile, text = 'Untitled')
    horizontal_scroll = Scrollbar(newFile, width=30, orient=HORIZONTAL)
    vertical_scroll = Scrollbar(newFile, width=30, orient=VERTICAL)
    textbox = Text(newFile, xscrollcommand=horizontal_scroll.set, yscrollcommand=vertical_scroll.set, wrap="none")
    vertical_scroll.config(command=textbox.yview)
    horizontal_scroll.config(command=textbox.xview)

    files[len(files)-1].pack(side=TOP, fill=BOTH)
    horizontal_scroll.pack(fill=X, side=BOTTOM)
    vertical_scroll.pack(fill=Y, side=RIGHT)
    textbox.pack(fill=BOTH, expand=True)

    texts.append([textbox, 0])
def new_window():
    tk = Tk()
    file = ttk.Notebook(tk)
    windows.append(tk)
    files.append(file)
    new_file()
    create_menu()
def create_menu():
    global windows
    toolbar = Menu(windows[len(windows)-1])
    File = Menu(toolbar)
    Edit = Menu(toolbar)
    View = Menu(toolbar)
    toolbar.add_cascade(label='File', menu=File)
    toolbar.add_cascade(label='Edit', menu=Edit)
    toolbar.add_cascade(label='View', menu=View)
    File.add_command(label='New File', command=new_file)
    File.add_command(label='New Window', command=new_window)
    File.add_command(label = 'Save as', command = save_as)
    File.add_command(label = 'Save', command = save)
    windows[len(windows)-1].config(menu=toolbar)

def save_as():
    f = filedialog.asksaveasfilename(defaultextension=".txt")
    if(f):
        with open(f, 'w') as newfile:
            newfile.write(texts[len(texts)-1][0].get(0.0, END))
        texts[len(texts)-1].append(f)
    else:
        return -1
def save():
    if texts[len(texts)-1][1] == 0:
        if save_as() != -1:
            texts[len(texts)-1][1] = 1
    else:
        f = texts[len(texts)-1][2]
        if f:
            with open(f, 'w') as newfile:
                newfile.write(texts[len(texts)-1][0].get(0.0,END))
def main():
    new_window()
    windows[len(windows)-1].mainloop()

if __name__ == "__main__":
    main()

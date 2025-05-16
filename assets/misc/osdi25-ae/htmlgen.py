import os
import urllib.parse


TABLE_START = """\
<table>
    <thead>
        <tr>
            <th>Presented</th>
            <th>Reproduced</th>
        </tr>
    </thead>
    <tbody>
"""
TABLE_END = """\
    </tbody>
</table>
"""

table_html = TABLE_START


def list_directory(folder_name):
    try:
        entries = os.listdir(folder_name)
        return sorted(entries)

    except FileNotFoundError:
        print(f"Error: The '{folder_name}' directory does not exist.")
    except PermissionError:
        print(f"Error: Permission denied when trying to access '{folder_name}'.")
    except Exception as e:
        print(f"An error occurred: {e}")


def add_table_row(p=None, r=None):
    global table_html
    table_html += "        <tr>\n"
    if p is None:
        table_html += "            <td></td>\n"
    else:
        table_html += f'            <td><a href="presented/{urllib.parse.quote(p)}">{p}</a></td>\n'
    if r is None:
        table_html += "            <td></td>\n"
    else:
        table_html += f'            <td><a href="reproduced/{urllib.parse.quote(r)}">{r}</a></td>\n'
    table_html += "        </tr>\n"


presented = list_directory("presented")
reproduced = list_directory("reproduced")

while len(presented) > 0:
    p = presented.pop(0)
    r = None
    try:
        reproduced.remove(p)
        add_table_row(p, p)
    except ValueError:
        add_table_row(p, None)
while len(reproduced) > 0:
    r = reproduced.pop(0)
    add_table_row(None, r)


table_html += TABLE_END

print(table_html)

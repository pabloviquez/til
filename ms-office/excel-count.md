# Excel - How to do a countdown

**Description**
I want to have a countdown from my last birthday until today.

|   | A          | B          | C |
| --- | --- | --- | --- |
| **1** | Today:     | `=NOW()`     |   |
| **2** | Last BDay: | `2021-09-11` |   |
| **3** | Elapsed:   | `=INT(B1-B2)&" days "&TEXT(B1-B2, "h"" hrs ""m"" min ""s"" sec""")` | |
| **4** |            |            |   |

Will show something like: `74 days 9 hrs 9 min 17 seg`
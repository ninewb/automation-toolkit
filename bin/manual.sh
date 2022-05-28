

# Usage: f_rc [command][optios]

# SAS specific return codes

# | All steps terminated normally          | SUCCESS       | 0 |
# | SAS issued warning(s)                  | WARNING       | 1 |
# | SAS issued error(s)                    | ERROR         | 2 |
# | User issued the ABORT statement        | INFORMATIONAL | 3 |
# | User issued the ABORT RETURN statement | FATAL         | 4 |
# | User issued the ABORT ABEND statement  | FATAL         | 5 |
# | SAS internal error                     | INFORMATIONAL | 6 |

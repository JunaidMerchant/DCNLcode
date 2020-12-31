#!/bin/bash
matlab -r "SubID= $1 ; SubP = $2 ; PpcBatchDir = $3 ; MNI = $4 ; Func = $5 ; TestFunc(SubID,SubP,PpcBatchDir, MNI, Func); pause; quit"
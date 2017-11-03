#!/usr/bin/env python

# -*- coding: UTF-8 -*-

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
#                                                                         #
#  Copyright (C) 2016 Simon Stuerz <stuerz.simon@gmail.com>               #
#                                                                         #
#  This file is part of Guitar Tools.                                     #
#                                                                         #
#  Guitar Tools is free software: you can redistribute it and/or modify   #
#  it under the terms of the GNU General Public License as published by   #
#  the Free Software Foundation, version 3 of the License.                #
#                                                                         #
#  Guitar Tools is distributed in the hope that it will be useful,        #
#  but WITHOUT ANY WARRANTY; without even the implied warranty of         #
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the           #
#  GNU General Public License for more details.                           #
#                                                                         #
#  You should have received a copy of the GNU General Public License      #
#  along with Guitar Tools. If not, see <http://www.gnu.org/licenses/>.   #
#                                                                         #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

import sys
import os
import traceback
import argparse
import json

baseNotes = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B']

parser = argparse.ArgumentParser(description='The generate-scales script can create a scale file for the given note.')
parser.add_argument('-v','--verbose', help='verbose mode for more information', action='store_true')
parser.add_argument('-i','--input', type=str, help='the base file with all C scales (default: \"base-scales.json\")', default='base-scales.json')
parser.add_argument('-p','--postfix', type=str, help='the postfix for the output file (default: \"-scales.json\")', default='-scales.json')
parser.add_argument('-n','--notes', type=str, nargs='*', help='the scale note to create.', choices=baseNotes)
arguments = parser.parse_args()


def loadBaseFile():
    # Reading C-scales.json file
    print('[+] Loading \'%s\':' % arguments.input)
    baseFile = open(arguments.input, 'r')
    data = json.load(baseFile)
    return data
    

def saveFile(note, data):
    print('[+] Write data to ' + note + arguments.postfix)
    scaleFile = open(note + arguments.postfix, 'w')
    scaleFile.write(json.dumps(data))


def printVerbose(string):
    if arguments.verbose:
        print(string)


def calculateScales(note, baseData):
    print('[+] Create scale for note ' + note)
    offset = baseNotes.index(note)
    print('    Offset: %s' % offset)
    # If this is C, we can return directly the baseData
    if offset is 0:
        return baseData
    
    scales = []
    for baseScale in baseData['scales']:
        print('    Creating %s %s' % (note, baseScale['name']))
        scale = { }
        scale['note'] = note
        scale['key'] = baseScale['key']
        scale['name'] = baseScale['name']
        scale['positions'] = calculatePositions(baseScale['positions'], offset)
        scales.append(scale)
    
    scaleData = { }
    scaleData['scales'] = scales
    return scaleData


def calculatePositions(positions, offset):
    newPositions = { } 
    for stringName in positions.keys():
        printVerbose('      -> Calculating positions for string ' + stringName + '\n         Shift (offset %s): %s' % (offset, positions[stringName]))
        newPositionNumbers = [ ]
        for positionNumber in positions[stringName]:
            newPositionNumberTmp = positionNumber + offset
            # If the new positionNumber is between [0, 12] we can continue
            if newPositionNumberTmp >= 0 and newPositionNumberTmp <= 12:
                printVerbose('          OK %s + %s --> %s' % (positionNumber, offset, newPositionNumberTmp))
                if newPositionNumberTmp is 12:
                    printVerbose('          OK %s --> %s' % (newPositionNumberTmp, 0))
                    newPositionNumbers.append(0)
                    
                newPositionNumbers.append(newPositionNumberTmp)
                continue
            
            newPositionNumber = newPositionNumberTmp % 12
            printVerbose('         ~OK %s + %s = %s  -->  %s' % (positionNumber, offset, newPositionNumberTmp, newPositionNumber))
            if not (newPositionNumber) in newPositionNumbers:
                newPositionNumbers.append(newPositionNumber)
                           
            
        newPositions[stringName] = sorted(newPositionNumbers, key=int)
        printVerbose('         Result: %s' % newPositions[stringName])

    return newPositions

#############################################################################################

baseData = loadBaseFile()

noteList = arguments.notes
if not noteList:
    noteList = baseNotes

print(noteList)

print('[+] Createing scale file for all notes')
for note in noteList:
    saveFile(note, calculateScales(note, baseData))

    






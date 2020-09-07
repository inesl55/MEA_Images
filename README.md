# MEA_Images

Scripts created during placement year to analyze MEA images with postnatal cortical cells platted on.

Image Segmentation code analyzes MEA images. It detects cells and cell clusters, labels MEA electrodes with their number (MEA with an 8x8 formation) and finds cell properties, such as area and coordinates.

MEA Image Crop allows to automatically crop an MEA image taken on the program WASABI, so as to analyze only the grid and not the surrounding areas of the MEA.

Fluorescent Image allows the detection of PV cells (due to Td-tomato) and to change electrode senstivity in order to detect cell activity.

PV Plots is a script that plots the MEA grid, PV cells and the electrodes that pick up activity from surronding cells (based on level of sensitivity applied).

#!/usr/bin/env python3

import mstar
import shutil
import os

mstar.Initialize()

if os.path.isdir("CASE"):
    shutil.rmtree("CASE")
os.makedirs("CASE")

m = mstar.LoadFromCatalog("Agitated System")
m.Export("CASE")
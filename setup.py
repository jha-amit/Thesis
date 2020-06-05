# -*- coding: utf-8 -*-
"""
Created on Mon May 25 19:09:14 2020

@author: amit jha
"""

from setuptools import setup
from Cython.Build import cythonize

setup(
    ext_modules=cythonize("function.pyx"),
)
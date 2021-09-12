#!/usr/bin/env python
# -*- coding: utf-8 -*-

from time import perf_counter


class Timer():

    def __init__(self):
        self.start_time = perf_counter()
        self.prev_time = self.start_time


    def lap(self):
        curr_time = perf_counter()
        lap_time  = curr_time - self.prev_time
        self.prev_time = curr_time
        return lap_time


    def total(self):
        return perf_counter() - self.start_time

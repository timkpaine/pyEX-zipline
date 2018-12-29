import pandas as pd
from pyEX import chartDF


def _get_data(symbol, start, end):
    df = chartDF(symbol, '5y')
    if start:
        df = df[df.index > start]
    if end:
        df = df[df.index < end]

    return df


def load_from_iex(symbols, start=None, end=None):
    data = {}
    for symbol in symbols:
        data[symbol] = _get_data(symbol, start, end)

    panel = pd.Panel(data)
    return panel

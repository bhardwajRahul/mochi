# Generated by Mochi Python compiler
from __future__ import annotations

import dataclasses
import typing

def risingTemperature(records: list[Weather]) -> list[int]:
	result = []
	i = 1
	while (i < len(records)):
		today = records[i]
		yesterday = records[(i - 1)]
		if (today.temperature > yesterday.temperature):
			result = (result + [today.id])
		i = (i + 1)
	return result

@dataclasses.dataclass
class Weather:
	id: int
	recordDate: str
	temperature: int

sampleWeather = [Weather(id=1, recordDate="2015-01-01", temperature=10), Weather(id=2, recordDate="2015-01-02", temperature=25), Weather(id=3, recordDate="2015-01-03", temperature=20), Weather(id=4, recordDate="2015-01-04", temperature=30)]

def rising_days():
	assert (risingTemperature(sampleWeather) == [2, 4])

def main():
	sampleWeather = [Weather(id=1, recordDate="2015-01-01", temperature=10), Weather(id=2, recordDate="2015-01-02", temperature=25), Weather(id=3, recordDate="2015-01-03", temperature=20), Weather(id=4, recordDate="2015-01-04", temperature=30)]
	rising_days()

if __name__ == "__main__":
	main()

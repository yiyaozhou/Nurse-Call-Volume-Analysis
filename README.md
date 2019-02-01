# Nurse Call Volume Analysis
This repository includes SQL query, R code for visualization and modeling.

* Problem: What is the nurse call volume pattern in a hospital? - from the perspective of an app development company focusing on hospital communication 
* Findings: 
  * Peak volume hours: 6-8AM, 6-8PM;
  * Different hospital/unit: nurse call volume varies a lot, but the patterns are same
  * Top 3 message types: Normal, Bed Exit, Bath Switch Triggered
  * March - June have higher nurse call volumes
* Nurse call volume prediction model (given location, time and message type): Gradient Boosting Model - accuracy: 87.50%
* Impact: Generate insights about hospital/unit workflows and help product team improve hospital staff assignment function

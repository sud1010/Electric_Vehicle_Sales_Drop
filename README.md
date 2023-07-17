# Electric_Vehicle_Sales_Drop
A SQL project
This project is part of bluetick.ai 's micro experience with the objective to determine a likely cause for the sales drop of the Zoom electric scooters.
## The Problem
Zoom Electric (ZE) is an electric vehicle venture owned by a renowned automotive manufacturer called ZOOM MOTORS India Private Limited. Recently, ZE introduced a new scooter model called Sprint in the electric two-wheeler segment. Initially, the sales numbers for Sprint Scooters were quite impressive during the first two weeks of its launch. However, unexpectedly, there was a sudden decline in sales thereafter.
## The Approach
To understand this sudden decline in sales an analysis was carried out to determine the probable cause. The analysis was done in two phases, first, the sales drop had to be quantified, then a sales growth comparison with other scooter variants was done, and finally, an email analysis to understand the marketing strategies followed during the promotion of the Sprint model.

Comparing the sales growth with other scooter models will help to assess whether there is a relationship between the launch date and the sales growth experienced in the first two to three weeks.

The email analysis will provide insights into how well the campaign engages recipients, whether they open the emails, and if they click on the provided links, helping to measure the overall impact and success of the campaign.
### Quantifying the sales drop
Validating the sales decline is crucial as it provides a clear understanding of the current sales performance. By doing so, we can identify any potential issues or trends that may be affecting sales. This information can then be used to make informed decisions and take necessary actions to address the decline.

Validating the sales drop by examining the cumulative sales volume over a rolling 7-day period. This approach allows for a consistent evaluation of sales performance throughout the week. Examining the calculated sales growth percentage to determine if it is negative or shows a decline. This confirms that sales have indeed decreased.

The formula used to calculate the change in cumulative sales volume over a rolling 7-day period between two consecutive dates is as follows,
*ΔSales = ((Sales at t - Sales at t-1) / Sales at t-1)*,
Where Sales" represents the cumulative sales volume over the last 7 days, "t" refers to the current time period, and "t-1" represents the previous time period

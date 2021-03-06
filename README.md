# Ebury technical test
SFDX deployment guide

Prerequisites:

<li>Access to Salesforce DevHub org.</li>
<li>Access to Fixer.io account which provide token.</li><br/>
Steps:<br/>
1. Run openTest.sh<br/>
1.1 Open Terminal and go to the openTest.sh file<br/>
1.2 chmod 755 openTest.sh<br/>
1.3 ./openTest.sh<br/>
1.4 Authorization on DevHub<br/>
1.5 Write scratch org name<br/>
1.6 After executing the script will open your scratch org<br/>
2. Create Default Organization Level Value in "Chatter Setting" custom setting with the "Queue Name" label filled in with the value "Trade reviewers"
<img src="screenshot/ChatterSetting.png"><br/>
3. Create Default Organization Level Value in "Fixer IO" custom setting with the "Endpoint" label filled in with the value "https://api.apilayer.com" and "Token" field filled in with the value security token whith provide Fixer IO.
<img src="screenshot/FixerIO.png"><br/><br/>

<center><strong>Overview</strong></center><br/>

<strong>REQ1</strong><br/>
<li>Sell Currency and Buy Currency are both picklist fields which reference Global Value Set "Currency"</li><br/>
<img src="screenshot/Model.png"><br/>
<li>Where ID is Auto Number with format "TR" + 7 numbers.</li><br/>

<strong>REQ2</strong><br/>
<li>We have Trade list view which show us all Trades and sorted by booking date</li><br/>
<img src="screenshot/tradeListView.png"><br/>
<li>We have New Trade button which open modal window. The create button is inactive until the fields are filled "Sell Currency", "Buy Currency" and "Sell Amount".</li><br/>
<img src="screenshot/newTradeBlankValues.png"><br/>
<li>When we choose Sell Currency and Buy Currency we got latest rate. </li><br/>
<img src="screenshot/newTradeLatestRate.png"><br/>
<li>When we fill incorrect value in "Sell Amount" field we can see validation</li><br/>
<img src="screenshot/newTradeValidation.png"><br/>
<li>When we fill Sell Amount, Buy Amount show us result</li><br/>
<img src="screenshot/newTradeSellAmount.png"><br/>
<li>When we click on create. The Trade record will created and our list view updated</li><br/>
<img src="screenshot/newTradeSuccess.png"><br/>

<strong>REQ3</strong><br/>
<li>After creating Trade record we send information in chatter for queue named "Trade reviewers"</li><br/>
<img src="screenshot/Chatter.png"><br/>

<strong>REQ4</strong><br/>
<li>Fixer IO bring us the latest currency rates</li><br/>
<li>The Endpoint and Token we store in protected custom settings</li><br/>

<strong>REQ5</strong><br/>
<li>We have script "openTest.sh" for deployment automation</li><br/>


<strong>Code Coverage</strong><br/>
<img src="screenshot/CodeCoverage.png"><br/>
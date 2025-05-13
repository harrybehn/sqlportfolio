##  Gaming Performance Monthly & Yearly Monitoring

### SQL Script Link : 

This Power BI dashboard is one of the projects that i created in my current job as a Data Analyst in an integrated resort but using fictional data. This dashboard provides insights into **gaming performance metrics** by analyzing **Unique Player count, Theoritical Win, Actual Win and Coin In Statistics** across different nationalities ,gaming areas and game type in weekly , monthly and yearly basis.

---

## 📊 Dashboard Overview

### 🔹 Unique Players, Theo Win, Actual Win & Coin In Analysis
- Monitor Unique Player, Theo Win, Actual Win & Coin In by **nationality** (Philippines, USA, Others).
- Compares Unique Player count, Theo Win, Actual Win & Coin In against **previous weeks** (P1W, P2W, P3W).
- Shows **percentage change** vs. the same day last week.

See dashboard screenshot
![Image](https://github.com/user-attachments/assets/94c4ca2c-7500-4a40-9162-0abaaa112b41)

### 🔹 Gaming Types & Areas
- **Game Types**: Slot, Table
- **Gaming Areas**: Mass Gaming, VIP Areas 1-4

### 📈 Trends & Visualizations
- **Bar charts** compare **yearly trends (2022, 2023, 2024)**.
- Tracks **monthly Coin In performance** for **overall and by nationality**.
- Shows **growth or decline trends**.
  
![Image](https://github.com/user-attachments/assets/c4f8ed57-9e2e-412e-8b8b-99556c366c1a) 
---

## 🚀 Key Features
✅ **Comparative Performance Tracking** – View daily, weekly, and yearly changes.  
✅ **Nationality-Based Analysis** – Understand gaming trends by demographic.  
✅ **Visual Insights** – Intuitive graphs for quick trend assessment.  
✅ **Gaming Area & Type Segmentation** – Detailed breakdown for slot & table games.   

---

## 📌 Usage
1. **Open Power BI** and load the `.pbix` file.  
2. **Explore the dashboards** for insights.  

---

## Steps followed 

### Step 1 : 
- **Load data into Power BI Desktop**.
- I use excel files in this project but in my actual work I would extract data from sql server and I would usually use native query for optimization.
- I used three datasets for this project namely, PlayerGamingSession1, Player, Nationality and PlayerGamingSession2. 
- PlayerGamingSession1 contains the columns PlayerID, Win(Actual Win), TheoWin, GamingArea, GameType and Dateplayed.
- PlayerGamingSession2 contains the columns PlayerID, Win(Actual Win), TheoWin, GamingArea, GameType, Month and Year.
- Player contains columns PlayerID and NationalityCode. Nationality contains columns NationalityCode and description.

### Step 2 :
- **Merge Queries**.
-  Next step is to merge Nationality table to Player table using the nationalitycode column to get the nationality description.
- Then merge Player table to PlayerGamingSession1 and PlayerGamingSession2. Close and Apply.

### Step 3 : Weekly Monitoring
### Step 3.1
- **Create Calculated Columns**.
- Create NationalityGroup column to group the nationaties into Philippines, USA and others.
  ![Image](https://github.com/user-attachments/assets/155a747f-41e3-4a3c-8ed9-1860eee9389a)
- Create DateRange column to compare weekly performance. I used a fixed date in this project but in my work I use a dynamic date using this dax formula: Yesterday = today() - 1, P1W = today() - 8, ..etc.
  ![Image](https://github.com/user-attachments/assets/12bd71c2-94be-4fac-add3-4eb2a226fb23)

### Step 3.2 :
- **Create Measures**.
- Create measures for total Unique Players, total TheoWin, total Actual Win and total Coin In.
  ![Image](https://github.com/user-attachments/assets/f2538be6-c8eb-47d2-97e3-d0512b70df08)

### Step 3.3 :
- **Create Visualization for Weekly Gaming performance**.
- Use Matrix visual to visualize Unique Players by nationality and by DataRange.
 ![Image](https://github.com/user-attachments/assets/ac00bf95-5bec-41d7-8802-a538a14956c2)

### Step 3.4 :
- **Create Visualization for Weekly Percentage Change**.
- Create measures for Weekly Percentage Change for Unique Player Count
  ![Image](https://github.com/user-attachments/assets/472d0991-26f8-4e96-aa76-16f2181474a2)
- Do the same for TheoWin, Actual Win and Coin In

### Step 3.5 :
- **Conditional Formatting for Weekly Percentage Change**.
- Create conditional formatting for Font Color.
  ![Image](https://github.com/user-attachments/assets/8b28f090-4437-4d5b-8823-50a4fd5c63bc)
- Add Icon using Conditional Formatting.
  ![Image](https://github.com/user-attachments/assets/0ee9285a-65a5-4e46-bc53-5af6bf2b1983)

### Step 3.6 :
- **Create Slicer**.
- Create slicers for Game Type and Gaming Area
  
![Image](https://github.com/user-attachments/assets/b68267e3-0cb2-45c6-912d-90d5542db634)

### Step 4 :Monthly and Yearly Performance
- **Create a Measure Slicer**
- I created a measure slicer so the viewer can see the **Unique Player** count, **Theowin**, **Actual Win** and **Coin In** yearly and monthly performance in one page.
- First step is to create a table with **Unique Player**, **TheoWin**, **Actual Win** and **Coin In** as olumns
  
  ![Image](https://github.com/user-attachments/assets/54ce1546-17b6-4d05-9f12-1ae02d00ccfa)
- Next Is to create a measure that retrieves the selected value from the MeasureSelection[MeasureName] column.
  
  ![Image](https://github.com/user-attachments/assets/663558fd-47e5-4567-b275-10db40d37710)
- Then finally create a measure that will dynamically switches between columns

  ![Image](https://github.com/user-attachments/assets/9d358501-8ffb-44e8-a514-3ea390c2adfa)

### Step 5 :
- **Create Bar Chart**
-  I created bar charts to compare the monthly performance and yearly performance using the year column, monthname column and the measure that i just created which is DisplayMeasure
- Monthly comparison

![Image](https://github.com/user-attachments/assets/9466faaa-3063-4898-89ab-348bff3d21a7)
- Yearly Comparison
  
  ![Image](https://github.com/user-attachments/assets/68a0ee55-7b2e-4a15-86dc-bdadac8627de)
- By Nationality

  ![Image](https://github.com/user-attachments/assets/00ef398b-1394-4455-bd3d-e1c9b2b7e907)
- Slicer

  ![Image](https://github.com/user-attachments/assets/cb0db8a5-caf6-4f4b-a534-aad5ebd6c246)

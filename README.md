🏏 T20 World Cup 2026 Data Analysis

An end-to-end data analysis project built using Python, SQL, and Power BI to analyze player and team performance in T20 World Cup matches.

---

🚀 Project Overview

This project follows a complete data pipeline:

JSON → Pandas → SQL → Power BI Dashboard

- Extracted raw match data (JSON files)
- Processed and cleaned data using Python (Pandas)
- Designed relational database and created views in PostgreSQL
- Built interactive dashboards in Power BI

---

📊 Key Features

- 📌 Player-level performance analysis (batting & bowling)
- 📌 Phase-wise analysis (Powerplay, Middle overs, Death overs)
- 📌 Strike rate, average, and economy breakdown
- 📌 Team-level comparisons
- 📌 Interactive navigation using slicers and buttons

---

🛠️ Tech Stack

- Python (Pandas) → Data cleaning & transformation
- PostgreSQL → Database design & SQL queries
- Power BI → Data visualization & dashboard
- GitHub → Project hosting

---

📂 Project Structure

data/
   raw/                # JSON match files
   processed/          # Cleaned CSV files

notebooks/
   data_processing.ipynb

sql/
   t20wc2026_dump.sql

powerbi/
   T20WCAnalysis.pbix

---

⚙️ How to Run

1. Import the SQL file into PostgreSQL:
   
   psql -U postgres -d your_db -f t20wc2026_dump.sql

2. Open Power BI file:
   
   - Connect to your PostgreSQL database
   - Refresh data

---

📈 Insights Generated

- Phase-wise batting performance reveals aggressive scoring in powerplay
- Death overs show highest strike rate but also higher risk
- Bowlers' economy varies significantly across phases
- Certain players dominate specific match phases

---

💡 Future Improvements

- Add advanced metrics (non-boundary strike rate, pressure index)
- Deploy dashboard online using Power BI Service
- Automate data pipeline

---

🙌 Acknowledgement

This project was built as part of my learning journey in data analytics and engineering.

---

🔗 Author

Pavan Kumar

import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import sys

# Set a professional style
sns.set_theme(style="whitegrid")

# 1. Load the Data
log_file = "pipeline_benchmark.csv"

try:
    df = pd.read_csv(log_file)
except FileNotFoundError:
    print(f"Error: Could not find {log_file}. Run the bash script first!")
    sys.exit(1)

# 2. Pivot Data for Stacked Bar Chart
# We want: Rows = Filenames, Columns = Steps, Values = Duration
df_pivot = df.pivot(index='Filename', columns='Step', values='Duration')

# 3. Plotting
plt.figure(figsize=(10, 6))

# Create Stacked Bar Chart
# colors: Dorado (Blue), Kraken (Green), Abricate (Red)
colors = ['#4C72B0', '#55A868', '#C44E52'] 
df_pivot.plot(kind='bar', stacked=True, color=colors, figsize=(10, 6), width=0.7)

# 4. Styling
plt.title('Pipeline Execution Time per Sample', fontsize=16, fontweight='bold')
plt.ylabel('Time (Seconds)', fontsize=12)
plt.xlabel('Sample Name', fontsize=12)
plt.xticks(rotation=45, ha='right')
plt.legend(title='Pipeline Step', bbox_to_anchor=(1.05, 1), loc='upper left')

plt.tight_layout()

# 5. Save the plot
output_img = "benchmark_graph.png"
plt.savefig(output_img, dpi=300)

print(f"Graph saved successfully as: {output_img}")

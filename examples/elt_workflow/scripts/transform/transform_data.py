import pandas as pd

def transform_data(input_path, output_path):
    """
    Loads data from input_path, performs transformations, and saves to output_path.
    """
    try:
        df = pd.read_csv(input_path)

        # Add a new column "sepal_length_category" based on "sepal_length"
        df['sepal_length_category'] = pd.cut(df['sepal_length'], bins=[0, 5, 6, float('inf')], labels=['Small', 'Medium', 'Large'])

        # Keep only rows 'sepal_length' > 5
        df_filtered = df[df['sepal_length'] > 5]

        # Save the transformed data
        df_filtered[['sepal_length', 'sepal_length_category']].to_csv(output_path, index=False)

        print(f"Transformation complete. Data saved to {output_path}")

    except FileNotFoundError:
        print(f"Error: Input file not found at {input_path}")
    except Exception as e:
        print(f"An error occurred during transformation: {e}")

if __name__ == "__main__":
    input_csv = '/mnt/data/data.csv'
    output_csv = '/mnt/data/transformed_data.csv'
    transform_data(input_csv, output_csv)
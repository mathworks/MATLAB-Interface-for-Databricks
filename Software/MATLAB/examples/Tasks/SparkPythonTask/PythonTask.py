import datetime

# Display Hello World
print("Hello World")

# Get and display current date and time
current_datetime = datetime.datetime.now()
print(f"Current Date and Time: {current_datetime}")

# Also display formatted date and time
formatted_datetime = current_datetime.strftime("%Y-%m-%d %H:%M:%S")
print(f"Formatted Date and Time: {formatted_datetime}")

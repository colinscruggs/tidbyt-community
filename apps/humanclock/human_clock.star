load("render.star", "render")
load("schema.star", "schema")
load("time.star", "time")
load("encoding/json.star", "json")

DEFAULT_LOCATION = {
    "lat": 32.8,
    "lng": 96.8,
    "locality": "Dallas",
}
DEFAULT_TIMEZONE = "US/Central"

twelve_hour = {
    0: "",
    1: "ONE",
    2: "TWO",
    3: "THREE",
    4: "FOUR",
    5: "FIVE",
    6: "SIX",
    7: "SEVEN",
    8: "EIGHT",
    9: "NINE",
    10: "TEN",
    11: "ELEVEN",
    12: "TWELVE",
}
minutes_ones = {
    0: "O'CLOCK",
    1: "O'ONE",
    2: "O'TWO",
    3: "O'THREE",
    4: "O'FOUR",
    5: "O'FIVE",
    6: "O'SIX",
    7: "O'SEVEN",
    8: "O'EIGHT",
    9: "O'NINE",
}
minutes_teens = {
    10: "TEN",
    11: "ELEVEN",
    12: "TWELVE",
    13: "THIRTEEN",
    14: "FOURTEEN",
    15: "FIFTEEN",
    16: "SIXTEEN",
    17: "SEVENTEEN",
    18: "EIGHTEEN",
    19: "NINETEEN",
}
minutes_tens = {
    20: "TWENTY",
    30: "THIRTY",
    40: "FOURTY",
    50: "FIFTY",
}

def twentyFourToTwelve(twentyFourHr):
    return twentyFourHr % 12

def getHumanTime(hour, minute):
    symbol = "PM" if hour > 11 else "AM"
    hour_display = twelve_hour[twentyFourToTwelve(hour)]
    minute_one_display = ''
    minute_two_display = ''

    if (minute < 10):
        # get display value 0-9  (i.e. 1:05 -> ONE O'FIVE || 2:00 -> TWO O'CLOCK)
        minute_one_display = minutes_ones[minute]
    elif (minute < 20):
        # get display value 11-19 (i.e. 2:15 -> TWO FIFTEEN)
        minute_one_display = minutes_teens[minute]
    else:
        # get display value 20-59 (i.e. 3:47 -> THREE FOURTY SEVEN)
        minute_one_display = minutes_tens[int(str(minute).elems()[0]) * 10]
        minute_two_display = twelve_hour[int(str(minute).elems()[1])]

    print(hour_display, minute_one_display, minute_two_display)

    return [hour_display, minute_one_display, minute_two_display]

def main(config):
    # get location from user config
    location = config.get("location")
    loc = json.decode(location) if location else DEFAULT_LOCATION

    # get timezone from location
    timezone = loc.get("timezone", DEFAULT_TIMEZONE)

    # get current time, translate
    now = time.now().in_location(timezone)
    # human = getHumanTime(now.hour, now.minute)
    human = getHumanTime(8, 19)


    # styling with padding(?)
    text = ['', '', '']
    text[0] = render.Text(human[0])
    text[1] = render.Text(human[1])
    text[2] = render.Animation(
        children = [
            render.Text(human[2]),
            render.Text(human[2] + '.'),
        ]
    )

    return render.Root(
        delay = 500,
        child = render.Padding( 
            pad = (4, 4, -1, 4),
            color= '#099',
            # time (left)
            child = render.Column(
                children = text
            ),
        ),
    )

def get_schema():
    return schema.Schema(
        version = "1",
        fields = [
            schema.Location(
                id = "location",
                name = "Location",
                icon = "place",
                desc = "Location for which to display time",
            )
        ],
    )

#ifndef DATE_H
#define DATE_H

#include <string>
#include <ctime>
#include "src/protocol_messages/ProtocolMessage.h"

using std::string;

class Date{
public:
    Date();
    Date(const Date& orig);
    Date(string date);

    string toString();

    string getYear() const;
    void setYear(string year);

    string getMonth() const;
    void setMonth(string month);

    string getDay() const;
    void setDay(string day);

    string getWeekday() const;
    void setWeekday(string weekday);

    string getHour() const;
    void setHour(string hour);

    string getMinute() const;
    void setMinute(string minute);

    string toHumanReadable();

private:
    string year;
    string month;
    string day;
    string weekday;
    string hour;
    string minute;

    static const string SUNDAY;
    static const string MONDAY;
    static const string TUESDAY;
    static const string WEDNESDAY;
    static const string THURSDAY;
    static const string FRIDAY;
    static const string SATURDAY;
    static const string ERROR_DAY;

    static const string FIELDS_SEP;
    static const string DATE_SEP;
    static const string TIME_SEP;

    static string decodeWeekday(int n_weekday);
    static int encodeWeekday(string weekday);
};

#endif // DATE_H
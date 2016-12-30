Public Class ReportParamsCalc
    'Possible DateRange values
    '1: Today
    '2: Yesterday
    '3: Last Week
    '4: Last Month
    '5: This Year
    '6: Date interval
    Public dtStart As DateTime
    Public dtEnd As DateTime
    Function GetDateValues(SomeValue As String, StartDate As DateTime, EndDate As DateTime, DateRange As Integer) As String
        Try
            Select Case DateRange
                Case 1
                    dtStart = Now.Date + New TimeSpan(0, 0, 0)
                    dtEnd = Now.Date + New TimeSpan(23, 59, 59)
                Case 2
                    dtStart = Now.Date.AddDays(-1) + New TimeSpan(0, 0, 0)
                    dtEnd = Now.Date.AddDays(-1) + New TimeSpan(23, 59, 59)
                Case 3
                    dtStart = Now.Date.AddDays(-(Now.DayOfWeek + 7)) + New TimeSpan(0, 0, 0)
                    dtEnd = Now.Date.AddDays(-(Now.DayOfWeek + 1)) + New TimeSpan(23, 59, 59)
                Case 4
                    dtStart = DateSerial(Now.Year, Now.Month - 1, 1) + New TimeSpan(0, 0, 0)
                    dtEnd = DateSerial(Now.Year, Now.Month, 0) + New TimeSpan(23, 59, 59)
                Case 5
                    dtStart = DateSerial(Now.Year, 1, 1) + New TimeSpan(0, 0, 0)
                    dtEnd = Now()
                Case 6
                    dtStart = StartDate
                    dtEnd = EndDate
                Case Else
                    SomeValue = "Function GetDateValues: Wrong DateRange value."
            End Select
        Catch ex As Exception
            SomeValue = "Function GetDateValues: " + ex.Message
        End Try
        Return SomeValue
    End Function
End Class

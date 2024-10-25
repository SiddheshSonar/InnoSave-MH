import React, { useState, useEffect } from "react";
import Center from "../../animated-components/Center";
import { CircularProgress, IconButton } from "@mui/material";
import AddCircleRoundedIcon from "@mui/icons-material/AddCircleRounded";
import InfoOutlinedIcon from "@mui/icons-material/InfoOutlined";
import DeleteIcon from "@mui/icons-material/Delete";
import AddExpenseModal from "../../components/AddExpenseModal";
import dayjs from "dayjs";
import { AdapterDayjs } from "@mui/x-date-pickers/AdapterDayjs";
import { LocalizationProvider } from "@mui/x-date-pickers/LocalizationProvider";
import { DateCalendar } from "@mui/x-date-pickers/DateCalendar";
import Api from "../../api";

const Tracker = () => {
  const [user, setUser] = useState(JSON.parse(localStorage.getItem("user")));
  const [loading, setLoading] = useState(true);
  const [expenses, setExpenses] = useState([]);
  const [allExpenses, setAllExpenses] = useState([]);
  const [change, setChange] = useState(false);
  const [open, setOpen] = useState(false);

  const handleClickOpen = () => {
    setOpen(true);
  };

  const handleClose = () => {
    setOpen(false);
  };

  useEffect(() => {
    setLoading(true);
    const fetchExpenses = async () => {
      await Api.getExpenses({
        email: user.email,
      })
        .then((res) => {
          setAllExpenses(res.data.groupedExpenses);
          // get current month
          const currentMonth = new Date().getMonth() + 1;
          const currentYear = new Date().getFullYear();
          console.log(currentMonth, currentYear);
          // check if the month_id is equal to the current month and year is equal to the current year if it is then set the expenses
          const currentExpenses = res.data.groupedExpenses.filter((expense) => {
            return (
              expense.month_id === currentMonth && expense.year === currentYear
            );
          });
          console.log(currentExpenses);
          if (currentExpenses.length > 0) {
            setExpenses(currentExpenses[0]);
          }
          setLoading(false);
        })
        .catch((err) => {
          console.log(err);
        });
    };
    fetchExpenses();
  }, [change]);

  return (
    <>
      {loading ? (
        <div className="flex justify-center items-center h-[80vh]">
          <CircularProgress />
        </div>
      ) : (
        <div className="flex flex-col items-start justify-start min-h-[80vh] h-full p-4">
          <div>
            <div>
              <h1 className="text-3xl font-bold">Expense Tracker</h1>
              <p className="text-sm">Track your expenses</p>
            </div>
            <div></div>
          </div>
          <div></div>
        </div>
      )}
    </>
  );
};

export default Tracker;

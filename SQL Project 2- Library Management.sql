create database project2;

use project2;

create table publishers(
pub_name varchar(255) primary key,
pub_address varchar(255),
pub_phone varchar(255));

create table borrower(
card_no int primary key auto_increment,
b_name varchar(255),
b_address varchar(255),
b_phone varchar(255)) auto_increment =100;

create table library_branch(
Branch_Id int primary key auto_increment,
Branch_name varchar(255),
Branch_address varchar(255)) auto_increment =1;

create table books(
Book_ID int primary key auto_increment,
Book_Title varchar(255),
Book_pubName varchar(255),
foreign key(Book_pubName)
references publishers(pub_name) on delete cascade) auto_increment =1;

create table Authors(
Au_ID int primary key auto_increment,
Au_BookID int,
Au_name varchar(255),
foreign key(Au_BookID)
references books(Book_ID) on delete cascade) auto_increment =100 ;

create table Book_copies(
CopiesID int primary key auto_increment,
C_BookID int,
C_BranchID int,
No_of_Copies int,
foreign key(C_BookID)
references books(Book_ID) on delete cascade,
foreign key(C_BranchID)
references library_branch(Branch_Id) on delete cascade) auto_increment =1;

create table Book_loans(
LoanID int primary key auto_increment,
L_BookID int,
L_BranchID int,
L_CardNo int ,
L_DateOut date,
L_DueDate date,
foreign key(L_BookID)
references books(Book_ID) on delete cascade,
foreign key(L_BranchID)
references library_branch(Branch_Id) on delete cascade,
foreign key(L_CardNo)
references borrower(card_no) on delete cascade) auto_increment =1;

use project2; 

-- 1) How many copies of the book titled "The Lost Tribe" are owned by the library branch whose name is "Sharpstown"?--
select * from (select bo.Book_title, bc.no_of_copies, lb.branch_name from 
books as bo join book_copies as bc
on bo.book_id = bc.c_bookid
join library_branch as lb
on bc.C_branchid = lb.branch_id) as LT
where book_title = "The Lost Tribe" and branch_name = "Sharpstown";



-- 2) How many copies of the book titled "The Lost Tribe" are owned by each library branch? --
select * from (select bo.Book_title, bc.no_of_copies, lb.branch_name from 
books as bo join book_copies as bc
on bo.book_id = bc.c_bookid
join library_branch as lb
on bc.C_branchid = lb.branch_id) as LT
where book_title = "The Lost Tribe";


-- 3) Retrieve the names of all borrowers who do not have any books checked out--
select br.card_no, br.b_name from borrower as br
where br.card_no not in (select L_CardNo from book_loans);


-- 4) For each book that is loaned out from the "Sharpstown" branch and whose DueDate is 2/3/18, 
-- retrieve the book title, the borrower's name, and the borrower's address. 

select b.book_title, bo.b_name as Borrower_name , bo.b_address as Borrower_Address  from books as b
join (select lb.branch_ID, lb.branch_name, bl.L_BookID , bl.L_cardNo , bl.L_DueDate from library_Branch as lb
join book_loans as bl 
on lb.branch_ID = bl.L_BranchID
where bl.L_duedate = "2018-03-02") as nt
on b.book_id = nt.L_bookID
join borrower as bo
on nt.L_cardNo = bo.Card_no
where branch_name = "Sharpstown" ;



-- 5) For each library branch, retrieve the branch name and the total number of books loaned out from that branch. --

select lb.Branch_name, co.No_of_books_loaned_Out from (select L_branchID , count(*) as No_of_books_loaned_Out from book_loans
group by L_branchID) as co
join library_branch as lb
on co.L_branchID = lb.Branch_ID;


-- 6) Retrieve the names, addresses, and number of books checked out for all borrowers who have more than five books checked out.-- 

select br.b_name as Borrower_name , br.b_address as Borrower_address , bl.No_of_Books_Checked_Out from borrower as br
join (select L_cardno , count(*) as No_of_Books_Checked_Out from book_loans
group by L_cardno) as bl
on br.card_no = bl.L_cardNo
where No_of_Books_Checked_Out > 5;

-- 7) For each book authored by "Stephen King", retrieve the title and the number of copies owned by the library branch whose name is "Central". -- 

select au.AU_name , co.Book_Title , co.No_of_copies , lb.Branch_name from (select bo.Book_ID , bo.Book_Title, bc.No_of_copies , bc.C_BranchID from Books as bo
join book_copies as bc
on bo.Book_ID = bc.C_BookID) as co
join library_branch as lb
on co.C_branchID = lb.branch_id
join authors as au
on au.AU_bookID = co.Book_ID
where lb.Branch_name = "Central" and au.AU_name = "Stephen king";

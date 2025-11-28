import axios from "@/axios";

export const $login = async (param: any) => {
  return await axios.get(
    "/user/selectByIdPwd?u_id=" +
      param.username +
      "&u_pwd=" +
      param.password +
      "&code=" +
      param.code
  );
};

// 1.user
export const $getUser = async () => {
  return await axios.get("/user/selectAll");
};

export const $selectUser = async (param: any) => {
  return await axios.get("/user/selectById/" + param);
};

export const $insertUser = async (param: any) => {
  return await axios.post("/user/insertById", param);
};

export const $deleteUser = async (param: any) => {
  return await axios.delete("/user/deleteById/" + param);
};

export const $updateUser = async (param: any) => {
  return await axios.post("/user/updateById", param);
};

export const $getUserCode = async () => {
  return await axios.get("/user/generateImageCode", {
    responseType: "arraybuffer",
  });
};

export const $importUserExcel = async (params: any) => {
  let data = await axios.post("/user/importExcel", params);
  return data;
};

// 2.user-role
export const $getUserRole = async () => {
  return await axios.get("/userRole/selectAll");
};

export const $selectUserRole = async (param: any) => {
  return await axios.get("/userRole/selectById/" + param);
};

export const $insertUserRole = async (param: any) => {
  return await axios.post("/userRole/insertById", param);
};

export const $deleteUserRole = async (param: any) => {
  return await axios.delete("/userRole/deleteById/" + param);
};

export const $updateUserRole = async (param: any) => {
  return await axios.post("/userRole/updateById", param);
};

// 3.role
export const $getRole = async () => {
  return await axios.get("/role/selectAll");
};

export const $selectRole = async (param: any) => {
  return await axios.get("/role/selectById/" + param);
};

export const $insertRole = async (param: any) => {
  return await axios.post("/role/insertById", param);
};

export const $deleteRole = async (param: any) => {
  return await axios.delete("/role/deleteById/" + param);
};

export const $updateRole = async (param: any) => {
  return await axios.post("/role/updateById", param);
};

export const $importRoleExcel = async (params: any) => {
  let data = await axios.post("/role/importExcel", params);
  return data;
};

// 4.role-menu
export const $getRoleMenu = async () => {
  return await axios.get("/roleMenu/selectAll");
};

export const $selectRoleMenu = async (param: any) => {
  return await axios.get("/roleMenu/selectById/" + param);
};

export const $insertRoleMenu = async (r_id: any, m_id: any) => {
  return await axios.post(
    "/roleMenu/insertById?r_id=" + r_id + "&m_id=" + m_id
  );
};

export const $deleteRoleMenu = async (r_id: any, m_id: any) => {
  return await axios.delete(
    "/roleMenu/deleteById/?r_id=" + r_id + "&m_id=" + m_id
  );
};

export const $deleteRoleMenuAll = async (r_id: any) => {
  return await axios.delete("/roleMenu/deleteAll?r_id=" + r_id);
};

export const $deleteRoleMenuAllWithUser = async (r_id: any) => {
  return await axios.delete("/roleMenu/deleteAllWithUser?r_id=" + r_id);
};

export const $updateRoleMenu = async (param: any) => {
  return await axios.post("/roleMenu/updateById", param);
};

// 5.menu
export const $getMenu = async () => {
  return await axios.get("/menu/selectAll");
};

export const $selectMenu = async (param: any) => {
  return await axios.get("/menu/selectById/" + param);
};

export const $insertMenu = async (param: any) => {
  return await axios.post("/menu/insertById", param);
};

export const $deleteMenu = async (param: any) => {
  return await axios.delete("/menu/deleteById/" + param);
};

export const $updateMenu = async (param: any) => {
  return await axios.post("/menu/updateById", param);
};

export const $importMenuExcel = async (params: any) => {
  let data = await axios.post("/menu/importExcel", params);
  return data;
};

// 6.sorts
export const $getSorts = async () => {
  return await axios.get("/sorts/selectAll");
};

export const $selectSorts = async (param: any) => {
  return await axios.get("/sorts/selectById/" + param);
};

export const $insertSorts = async (param: any) => {
  return await axios.post("/sorts/insertById", param);
};

export const $deleteSorts = async (param: any) => {
  return await axios.delete("/sorts/deleteById/" + param);
};

export const $updateSorts = async (param: any) => {
  return await axios.post("/sorts/updateById", param);
};

export const $importSortsExcel = async (params: any) => {
  let data = await axios.post("/sorts/importExcel", params);
  return data;
};

// 7.books
export const $getBooks = async () => {
  return await axios.get("/books/selectAll");
};

export const $selectBooks = async (param: any) => {
  return await axios.get("/books/selectById/" + param);
};

export const $insertBooks = async (param: any) => {
  return await axios.post("/books/insertById", param);
};

export const $deleteBooks = async (param: any) => {
  return await axios.delete("/books/deleteById/" + param);
};

export const $updateBooks = async (param: any) => {
  return await axios.post("/books/updateById", param);
};

export const $importBooksExcel = async (params: any) => {
  let data = await axios.post("/books/importExcel", params);
  return data;
};

// 8.bookno
export const $getBookno = async () => {
  return await axios.get("/bookno/selectAll");
};

export const $selectBookno = async (param: any) => {
  return await axios.get("/bookno/selectById/" + param);
};

export const $insertBookno = async (param: any) => {
  return await axios.post("/bookno/insertById", param);
};

export const $deleteBookno = async (param: any) => {
  return await axios.delete("/bookno/deleteById/" + param);
};

export const $updateBookno = async (param: any) => {
  return await axios.post("/bookno/updateById", param);
};

export const $selectBooknoByUid = async (param: any) => {
  return await axios.get("/bookno/selectByUid?u_id=" + param);
};

export const $selectBooknoByBname = async (param: any) => {
  return await axios.get("/bookno/selectByBname?b_name=" + param);
};

export const $importBooknoExcel = async (params: any) => {
  let data = await axios.post("/bookno/importExcel", params);
  return data;
};

// 9.borrow
export const $getBorrow = async () => {
  return await axios.get("/borrow/selectAll");
};

export const $selectBorrow = async (param: any) => {
  return await axios.get("/borrow/selectById/" + param);
};

export const $insertBorrow = async (param: any) => {
  return await axios.post("/borrow/insertById", param);
};

export const $deleteBorrow = async (param: any) => {
  return await axios.delete("/borrow/deleteById/" + param);
};

export const $updateBorrow = async (param: any) => {
  return await axios.post("/borrow/updateById", param);
};

export const $borrowBook = async (param: any) => {
  return await axios.post(
    "borrow/borrowBook?u_id=" +
      param.u_id +
      "&b_code=" +
      param.b_code +
      "&br_borrow=" +
      param.br_borrow
  );
};

export const $selectBorrowByUid = async (param: any) => {
  return await axios.get("/borrow/selectByUid?u_id=" + param);
};

export const $importBorrowExcel = async (params: any) => {
  let data = await axios.post("/borrow/importExcel", params);
  return data;
};

export const $selectByEcharts = async (start: any, end: any) => {
  return await axios.get(
    "borrow/selectByEcharts?start=" + start + "&end=" + end
  );
};

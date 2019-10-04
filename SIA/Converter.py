import xlsxwriter
import csv

def csv_to_xlsx(csv_paths):
  book = xlsxwriter.Workbook('Resultados/Compilado.xlsx')
  bold_f = book.add_format({'bold': True})

  for file in csv_paths:
    with open(file, 'r') as csv_file:
      data = list(csv.reader(csv_file, delimiter='\t'))
      sheet = book.add_worksheet(file.split('/')[-1].split('.')[0])
      sheet.set_row(0, None, bold_f)

      max_col = max([len(row) for row in data])
      column_lengths = [10]*max_col
      
      line = 0
      for row_data in data:
        sheet.write_row(line, 0, row_data)

        col = 0
        for d in row_data:
          column_lengths[col] = max(len(d), column_lengths[col]) 
          col += 1

        line += 1
      
      col = 0
      for column in column_lengths:
        sheet.set_column(col, col, column_lengths[col] + 3)
        col += 1
      
      if not file.endswith('Resumen General.csv'):
        sheet.autofilter(0, 0, line - 1, len(data[0]) - 1)
      

  book.close()
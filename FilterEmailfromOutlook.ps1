Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create form and add controls
$form = New-Object System.Windows.Forms.Form
$form.Text = "Filter Emails from Outlook"
$form.Size = New-Object System.Drawing.Size(500, 300)
$form.StartPosition = "CenterScreen"

#SubjectLabel
$subjectLabel = New-Object System.Windows.Forms.Label
$subjectLabel.Location = New-Object System.Drawing.Point(10, 40) # Updated location
$subjectLabel.Size = New-Object System.Drawing.Size(200, 20)
$subjectLabel.Text = "Subject Filter:"
$form.Controls.Add($subjectLabel)

#subjectTextBox
$subjectTextBox = New-Object System.Windows.Forms.TextBox
$subjectTextBox.Location = New-Object System.Drawing.Point(220, 40) # Updated location
$subjectTextBox.Size = New-Object System.Drawing.Size(250, 20)
$form.Controls.Add($subjectTextBox)

#attachmentNameLabel
$attachmentNameLabel = New-Object System.Windows.Forms.Label
$attachmentNameLabel.Location = New-Object System.Drawing.Point(10, 80)
$attachmentNameLabel.Size = New-Object System.Drawing.Size(200, 20)
$attachmentNameLabel.Text = "Attachment Name Filter:"
$form.Controls.Add($attachmentNameLabel)

#attachmentNameTextBox
$attachmentNameTextBox = New-Object System.Windows.Forms.TextBox
$attachmentNameTextBox.Location = New-Object System.Drawing.Point(220, 80)
$attachmentNameTextBox.Size = New-Object System.Drawing.Size(250, 20)
$form.Controls.Add($attachmentNameTextBox)

#attachmentTypeLabel
$attachmentTypeLabel = New-Object System.Windows.Forms.Label
$attachmentTypeLabel.Location = New-Object System.Drawing.Point(10, 120)
$attachmentTypeLabel.Size = New-Object System.Drawing.Size(200, 20)
$attachmentTypeLabel.Text = "Attachment Type Filter:"
$form.Controls.Add($attachmentTypeLabel)

#attachmentTypeComboBox
$attachmentTypeComboBox = New-Object System.Windows.Forms.ComboBox
$attachmentTypeComboBox.Location = New-Object System.Drawing.Point(220, 120)
$attachmentTypeComboBox.Size = New-Object System.Drawing.Size(250, 20)
$attachmentTypeComboBox.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
$attachmentTypeComboBox.Items.AddRange(@(".pdf", ".docx", ".xlsx",".png",".jpg",".jpeg",".log","*.*"))
$form.Controls.Add($attachmentTypeComboBox)

#outputFolderLabel
$outputFolderLabel = New-Object System.Windows.Forms.Label
$outputFolderLabel.Location = New-Object System.Drawing.Point(10, 160)
$outputFolderLabel.Size = New-Object System.Drawing.Size(200, 20)
$outputFolderLabel.Text = "Output Folder Location:"
$form.Controls.Add($outputFolderLabel)

#outputFolderTextBox
$outputFolderTextBox = New-Object System.Windows.Forms.TextBox
$outputFolderTextBox.Location = New-Object System.Drawing.Point(220, 160)
$outputFolderTextBox.Size = New-Object System.Drawing.Size(230, 20)
$form.Controls.Add($outputFolderTextBox)

#folderSelectButton
$folderButton = New-Object System.Windows.Forms.Button
$folderButton.Location = New-Object System.Drawing.Point(450, 160)
$folderButton.Size = New-Object System.Drawing.Size(20, 20)
$folderButton.Text = "..."
$folderButton.Add_Click({
    $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    $folderBrowser.ShowDialog() | Out-Null
    $outputFolderTextBox.Text = $folderBrowser.SelectedPath
})
$form.Controls.Add($folderButton)

$button = New-Object System.Windows.Forms.Button
$button.Location = New-Object System.Drawing.Point(200, 200)
$button.Size = New-Object System.Drawing.Size(100, 30)
$button.Text = "Filter Emails"
$button.Add_Click({
    # Create an instance of Outlook.Application and get the Namespace
    $outlook = New-Object -ComObject Outlook.Application
    $namespace = $outlook.GetNamespace("MAPI")

    # Get the Inbox folder
    $inbox = $namespace.GetDefaultFolder([Microsoft.Office.Interop.Outlook.OlDefaultFolders]::olFolderInbox)

    # Specify the subject to filter emails
    $subjectFilter = $subjectTextBox.Text

    # Specify the attachment name filter
    $attachmentNameFilter = $attachmentNameTextBox.Text

    # Specify the attachment type filter
    $attachmentTypeFilter = $attachmentTypeComboBox.Text

    # Specify the directory to save attachments
    $saveDirectory = $outputFolderTextBox.Text
    [System.Windows.Forms.MessageBox]::Show("$subjectFilter $attachmentNameFilter $attachmentTypeFilter $saveDirectory")
    # Iterate over each email in the Inbox
    # foreach ($mail in $inbox.Items) {
    #     # Check if the subject matches the filter
    #     if ($mail.Subject.contains($subjectFilter)) {
    #         # Iterate over each attachment in the email
    #         foreach ($attachment in $mail.Attachments) {
    #             # Check if the attachment name and type match the filters
    #             if ($attachment.FileName.contains($attachmentNameFilter) -and $attachment.FileName.EndsWith($attachmentTypeFilter)) {
    #                 # Save the attachment to the specified directory
    #                 $attachment.SaveAsFile((Join-Path -Path $saveDirectory -ChildPath $attachment.FileName))
    #             }
    #         }
    #     }
    # }

    # Show message box when done
    [System.Windows.Forms.MessageBox]::Show("Emails filtered and attachments saved to $saveDirectory")
})

$form.Controls.Add($button)

# Show the form
$form.ShowDialog() | Out-Null

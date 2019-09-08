#ifndef CONTACTIMPORTER_H
#define CONTACTIMPORTER_H

#include <QObject>
#include <KContacts/VCardConverter>

class ContactImporter : public QObject
{
    Q_OBJECT
public:
    explicit ContactImporter(QObject *parent = nullptr);
    Q_INVOKABLE void importVCards(const QUrl &path);

private:
    KContacts::VCardConverter m_converter;
};

#endif // CONTACTIMPORTER_H

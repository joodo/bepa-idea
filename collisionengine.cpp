#include <QMap>
#include <QtMath>

#include "collisionengine.h"


QRectF getRectFromItem(QQuickItem *item) {
    return QRectF(item->x(), item->y(), item->width(), item->height());
}

bool collision(QQuickItem *item1, QQuickItem *item2) {
    return getRectFromItem(item1).intersects(getRectFromItem(item2));
}

qreal getAngle(QQuickItem *from, QQuickItem *to) {
    qreal dx = (to->x()+to->width()/2) - (from->x()+from->width()/2);
    qreal dy = (to->y()+to->height()/2) - (from->y()+from->height()/2);
    return qAtan2(dy, dx);
}


CollisionEngine::CollisionEngine(QObject *parent) : QObject(parent)
{
    timer = new QTimer(this);
    connect(timer, SIGNAL(timeout()), this, SLOT(update()));
}

void CollisionEngine::setNodesContainer(QQuickItem *canvas)
{
    this->canvas = canvas;
}

void CollisionEngine::itemsChanged(const QVariantList &changedItems)
{
    this->waitToArrange.clear();
    for (auto i : changedItems) {
        this->waitToArrange.enqueue(i.value<QQuickItem*>());
    }
    timer->start(CollisionEngine::MSEC);
}

void CollisionEngine::update()
{
    QList<QQuickItem *> nodeList = this->canvas->childItems();
    QMap<QQuickItem *, qreal> forceAngle;  // 节点受的力角度，用于移动
    bool moved = false;

    for (int position = 0; position < this->waitToArrange.length(); position++) {
        auto node = this->waitToArrange[position];

        // 移动！
        if (forceAngle.contains(node)) {
            qreal angle = forceAngle[node];
            moved = true;
            node->setX(node->x() + CollisionEngine::STEP*qCos(angle));
            node->setY(node->y() + CollisionEngine::STEP*qSin(angle));
        }

        // 判断碰撞
        for (auto checkNode : nodeList) {
            if (checkNode == node) {
                continue;
            }
            if (collision(node, checkNode)) {
                int checkPosition = this->waitToArrange.indexOf(checkNode);
                if (checkPosition == -1)  {
                    // 队列中没有，推进队列
                    this->waitToArrange.enqueue(checkNode);
                    forceAngle[checkNode] = getAngle(node, checkNode);
                } else if (checkPosition > position) {
                    // 修正推力方向
                    forceAngle[checkNode] = getAngle(node, checkNode);
                }
            }
        }
    }

    if (!moved) {
        this->timer->stop();
    }
}
